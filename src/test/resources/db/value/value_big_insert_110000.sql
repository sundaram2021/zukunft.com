PREPARE value_big_insert_110000 (text, bigint, numeric) AS
    INSERT INTO values_big
                (group_id, user_id, numeric_value, last_update)
         VALUES ($1, $2, $3, Now())
    RETURNING group_id;