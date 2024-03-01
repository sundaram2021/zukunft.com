PREPARE word_by_user_list FROM
    'SELECT
            s.word_id,
            s.word_name,
            l.user_id,
            l.user_name,
            l.code_id,
            l.ip_address,
            l.email,
            l.first_name,
            l.last_name,
            l.term_id,
            l.source_id,
            l.user_profile_id
       FROM user_words s
  LEFT JOIN users l
         ON s.user_id = l.user_id
      WHERE s.word_id = ?
        AND (s.excluded <> ? OR s.excluded IS NULL)';