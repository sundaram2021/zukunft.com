PREPARE source_type_all FROM
   'SELECT source_type_id,
           type_name,
           description,
           code_id
      FROM source_types
  ORDER BY source_type_id
     LIMIT ?
    OFFSET ?';