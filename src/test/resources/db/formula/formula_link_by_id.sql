PREPARE formula_link_by_id (bigint, bigint) AS
    SELECT
               s.formula_link_id,
               u.formula_link_id AS user_formula_link_id,
               s.user_id,
               s.formula_id,
               s.phrase_id,
               CASE WHEN (u.formula_link_type_id  IS NULL) THEN s.formula_link_type_id  ELSE u.formula_link_type_id  END AS formula_link_type_id,
               CASE WHEN (u.order_nbr             IS NULL) THEN s.order_nbr             ELSE u.order_nbr             END AS order_nbr,
               CASE WHEN (u.excluded              IS NULL) THEN s.excluded              ELSE u.excluded              END AS excluded,
               CASE WHEN (u.share_type_id         IS NULL) THEN s.share_type_id         ELSE u.share_type_id         END AS share_type_id,
               CASE WHEN (u.protect_id            IS NULL) THEN s.protect_id            ELSE u.protect_id            END AS protect_id
          FROM formula_links s
     LEFT JOIN user_formula_links u ON s.formula_link_id = u.formula_link_id
           AND u.user_id = $1
         WHERE s.formula_link_id = $2;