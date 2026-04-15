CREATE SCHEMA hw06;
SET SEARCH_PATH TO hw06;

CREATE TABLE accounts (
    account_id SERIAL PRIMARY KEY,
    owner_name VARCHAR(100),
    balance NUMERIC(12,2),
    status VARCHAR(10) DEFAULT 'ACTIVE'
);

CREATE TABLE transactions (
    trans_id SERIAL PRIMARY KEY,
    from_account INT REFERENCES accounts(account_id),
    to_account INT REFERENCES accounts(account_id),
    amount NUMERIC(12,2),
    status VARCHAR(20) DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT NOW()
);

INSERT INTO accounts (owner_name, balance, status) VALUES
    ('Nguyen Van A', 1000000.00, 'ACTIVE'),
    ('Nguyen Van B', 500000.00, 'ACTIVE'),
    ('Nguyen Van C', 750000.00, 'LOCKED');

SELECT * FROM accounts;

CREATE OR REPLACE PROCEDURE transact_money (
    from_account_in INT,
    to_account_in INT,
    amount_in NUMERIC(12,2)
)
language plpgsql as $$
DECLARE
    v_from_status VARCHAR(10);
    v_from_balance NUMERIC(12,2);
    v_to_balance NUMERIC(12,2);
    v_trans_id INT;
BEGIN
    BEGIN

        IF from_account_in=to_account_in THEN
            RAISE EXCEPTION 'Tài khoản nhận và tài khoản gửi trùng nhau.';
        END IF;

        IF from_account_in < to_account_in THEN
            SELECT balance,status INTO v_from_balance,v_from_status
                                  FROM accounts WHERE account_id=from_account_in
            FOR UPDATE;
            SELECT balance INTO v_to_balance FROM accounts WHERE account_id=to_account_in
            FOR UPDATE;
        ELSE
            SELECT balance INTO v_to_balance FROM accounts WHERE account_id=to_account_in
            FOR UPDATE;
            SELECT balance,status INTO v_from_balance,v_from_status
                                  FROM accounts WHERE account_id=from_account_in
            FOR UPDATE;
        END IF;

        IF v_from_balance IS NULL THEN
            RAISE EXCEPTION 'Tài khoản gửi không tồn tại.';
        END IF;

        IF v_to_balance IS NULL THEN
            RAISE EXCEPTION 'Tài khoản nhận không tồn tại.';
        END IF;

        INSERT INTO transactions (from_account, to_account, amount) VALUES
            (from_account_in, to_account_in, amount_in)
        RETURNING trans_id INTO v_trans_id;

        IF v_from_status != 'ACTIVE' THEN
            RAISE EXCEPTION 'Tài khoản gừi không hoạt động.';
        END IF;

        IF v_from_balance < amount_in THEN
            RAISE EXCEPTION 'Tài khoản gừi không đủ tiền.';
        END IF;

        UPDATE accounts SET balance = v_from_balance - amount_in WHERE account_id=from_account_in;
        UPDATE accounts SET balance = v_to_balance + amount_in WHERE account_id=to_account_in;

        UPDATE transactions SET status='COMPLETED' WHERE trans_id=v_trans_id;

        -- Nếu chạy đến đây không có lỗi, PostgreSQL sẽ tự động COMMIT khi kết thúc khối DO.
        RAISE NOTICE 'Giao dịch % thành công! Đã chuyển % từ % sang %.', v_trans_id, amount_in, from_account_in, to_account_in;

    EXCEPTION
        when others then
            -- rollback lại transaction
            rollback;
            -- Đẩy exception lên mức cao nhất của hệ thống để xử lý
            raise;

    END;
END;
$$;

-- Completed
CALL transact_money(1, 2, 200000.00);
-- ERROR: Tài khoản nhận và tài khoản gửi trùng nhau.
CALL transact_money(1, 1, 100000.00);
-- ERROR: Tài khoản gửi không tồn tại.
CALL transact_money(4, 1, 100000.00);
-- ERROR: Tài khoản nhận không tồn tại.
CALL transact_money(1, 4, 100000.00);
-- ERROR: Tài khoản gừi không hoạt động.
CALL transact_money(3, 1, 100000.00);
-- ERROR: Tài khoản gừi không đủ tiền.
CALL transact_money(2, 1, 1000000.00);

SELECT * FROM accounts;
SELECT * FROM transactions;