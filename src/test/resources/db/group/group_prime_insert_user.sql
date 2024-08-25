PREPARE group_prime_insert_user (bigint, bigint, text, text) AS
    INSERT INTO user_groups_prime
                (group_id, user_id, group_name, description)
         VALUES ($1, $2, $3, $4)
    RETURNING group_id;