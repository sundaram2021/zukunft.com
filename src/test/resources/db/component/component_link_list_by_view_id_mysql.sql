PREPARE component_link_list_by_view_id FROM
    'SELECT s.component_link_id,
            u.component_link_id AS user_component_link_id,
            s.user_id,
            s.view_id,
            s.component_id,
            l.code_id,
            l.ui_msg_code_id,
            IF(u.order_nbr           IS NULL, s.order_nbr,            u.order_nbr)         AS order_nbr,
            IF(u.position_type_id    IS NULL, s.position_type_id,     u.position_type_id)  AS position_type_id,
            IF(u.excluded            IS NULL, s.excluded,             u.excluded)          AS excluded,
            IF(u.share_type_id       IS NULL, s.share_type_id,        u.share_type_id)     AS share_type_id,
            IF(u.protect_id          IS NULL, s.protect_id,           u.protect_id)        AS protect_id,
            IF(ul.description        IS NULL, l.description,         ul.description)       AS description,
            IF(ul2.component_type_id IS NULL, l2.component_type_id, ul2.component_type_id) AS component_type_id2,
            IF(ul2.word_id_row       IS NULL, l2.word_id_row,       ul2.word_id_row)       AS word_id_row2,
            IF(ul2.link_type_id      IS NULL, l2.link_type_id,      ul2.link_type_id)      AS link_type_id2,
            IF(ul2.formula_id        IS NULL, l2.formula_id,        ul2.formula_id)        AS formula_id2,
            IF(ul2.word_id_col       IS NULL, l2.word_id_col,       ul2.word_id_col)       AS word_id_col2,
            IF(ul2.word_id_col2      IS NULL, l2.word_id_col2,      ul2.word_id_col2)      AS word_id_col22,
            IF(ul2.excluded          IS NULL, l2.excluded,          ul2.excluded)          AS excluded2,
            IF(ul2.share_type_id     IS NULL, l2.share_type_id,     ul2.share_type_id)     AS share_type_id2,
            IF(ul2.protect_id        IS NULL, l2.protect_id,        ul2.protect_id)        AS protect_id2
       FROM component_links s
  LEFT JOIN user_component_links u ON  s.component_link_id =   u.component_link_id AND  u.user_id = ?
  LEFT JOIN components l           ON  s.component_id      =   l.component_id
  LEFT JOIN user_components ul     ON  l.component_id      =  ul.component_id      AND ul.user_id = ?
  LEFT JOIN components l2          ON  s.component_id      =  l2.component_id
  LEFT JOIN user_components ul2    ON l2.component_id      = ul2.component_id      AND ul2.user_id = ?
     WHERE s.view_id = ?
  ORDER BY s.order_nbr';
