PREPARE user_list_by_profiles FROM
   'SELECT s.user_id,
           s.user_name,
           s.code_id,
           s.ip_address,
           s.email,
           s.first_name,
           s.last_name,
           s.term_id,
           s.source_id,
           s.user_profile_id,
           l.right_level
      FROM users s
 LEFT JOIN user_profiles l ON s.user_profile_id = l.user_profile_id
     WHERE l.right_level >= ?';