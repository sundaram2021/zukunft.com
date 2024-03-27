PREPARE verb_all (bigint, bigint) AS
    SELECT
           verb_id,
           verb_name,
           code_id,
           description,
           name_plural,
           name_reverse,
           name_plural_reverse,
           formula_name,
           words
      FROM verbs
  ORDER BY verb_id
     LIMIT $1
    OFFSET $2;