PREPARE value_prime_p3_insert_user FROM
    'INSERT INTO user_values_prime
                 (phrase_id_1, phrase_id_2, phrase_id_3, user_id)
          VALUES (?, ?, ?, ?)';