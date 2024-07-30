<?php

/*

    test/unit/value_phrase_link.php - unit testing of the VALUE PHRASE LINK functions
    -------------------------------


    This file is part of zukunft.com - calc with words

    zukunft.com is free software: you can redistribute it and/or modify it
    under the terms of the GNU General Public License as
    published by the Free Software Foundation, either version 3 of
    the License, or (at your option) any later version.
    zukunft.com is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with zukunft.com. If not, see <http://www.gnu.org/licenses/agpl.html>.

    To contact the authors write to:
    Timon Zielonka <timon@zukunft.com>

    Copyright (c) 1995-2022 zukunft.com AG, Zurich
    Heang Lor <heang@zukunft.com>

    http://zukunft.com

*/

namespace unit;

include_once MODEL_VALUE_PATH . 'value_phrase_link.php';
include_once MODEL_VALUE_PATH . 'value_phrase_link_list.php';

use cfg\db\sql;
use cfg\phrase;
use cfg\db\sql_db;
use cfg\value\value;
use cfg\value\value_phrase_link;
use cfg\value\value_phrase_link_list;
use test\test_cleanup;

class value_phrase_link_tests
{

    function run(test_cleanup $t): void
    {

        global $usr;

        // init
        $db_con = new sql_db();
        $sc = new sql();
        $t->name = 'value_phrase_link->';
        $t->resource_path = 'db/value/';

        $t->header('Unit tests of the value phrase link class (src/main/php/model/value/value_phrase_link.php)');


        $t->subheader('Database query creation tests');

        // sql to load a value phrase link by id
        $val_phr_lnk = new value_phrase_link($usr);
        $val_phr_lnk->set_id(1);
        $t->assert_sql_by_obj_vars($db_con, $val_phr_lnk);

        // sql to load a value phrase link by value, phrase and user id
        $val_phr_lnk = new value_phrase_link($usr);
        $val_phr_lnk->set_id(0);
        $val_phr_lnk->val->set_id(1);
        $val_phr_lnk->phr->set_id(2);
        $t->assert_sql_by_obj_vars($db_con, $val_phr_lnk);


        $t->subheader('Database list query creation tests');

        // sql to load a value phrase link list by value id
        $val_phr_lnk_lst = new value_phrase_link_list($usr);
        $phr = new phrase($usr);
        $phr->set_id(2);
        $this->assert_sql_lst_all($t, $db_con, $val_phr_lnk_lst, $phr);

        // sql to load a value phrase link list by phrase id
        $val_phr_lnk_lst = new value_phrase_link_list($usr);
        $val = new value($usr);
        $val->set_id(3);
        $this->assert_sql_lst_all($t, $db_con, $val_phr_lnk_lst, null, $val);

    }

    /**
     * test the SQL statement creation for a value phrase link list in all SQL dialect
     * and check if the statement name is unique
     *
     * @param test_cleanup $t the test environment
     * @param sql_db $db_con the test database connection
     * @param value_phrase_link_list $lst filled with an id to be able to load
     * @param phrase|null $phr the phrase used for selection
     * @param value|null $val the value used for selection
     * @return void
     */
    private function assert_sql_lst_all(test_cleanup $t, sql_db $db_con, value_phrase_link_list $lst, ?phrase $phr = null, ?value $val = null): void
    {
        // check the Postgres query syntax
        $db_con->db_type = sql_db::POSTGRES;
        $qp = $lst->load_sql($db_con, $phr, $val);
        $t->assert_qp($qp, $db_con->db_type);

        // check the MySQL query syntax
        $db_con->db_type = sql_db::MYSQL;
        $qp = $lst->load_sql($db_con, $phr, $val);
        $t->assert_qp($qp, $db_con->db_type);
    }

}