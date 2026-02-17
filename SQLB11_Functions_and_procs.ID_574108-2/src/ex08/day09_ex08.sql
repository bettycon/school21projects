CREATE OR REPLACE FUNCTION fnc_fibonacci(pstop integer DEFAULT 10)
RETURNS TABLE (num integer) AS $$
DECLARE
    a integer := 0;
    b integer := 1;
    next_fib integer;
BEGIN
    IF pstop < 0 THEN
        RETURN;
    END IF;

    IF pstop >= a THEN
        num := a;
        RETURN NEXT;
    END IF;

    IF pstop >= b THEN
        num := b;
        RETURN NEXT;
    END IF;

    LOOP
        next_fib := a + b;
        IF next_fib >= pstop THEN
            EXIT;
        END IF;
        num := next_fib;
        RETURN NEXT;
        a := b;
        b := next_fib;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM fnc_fibonacci(100);
SELECT * FROM fnc_fibonacci();