<?php

/*

    test/unit/result_list.php - unit testing of the FORMULA VALUE functions
    --------------------------------
  

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

include_once WEB_FIGURE_PATH . 'figure_list.php';

use cfg\db\sql;
use cfg\fig_ids;
use cfg\figure;
use cfg\figure_list;
use cfg\db\sql_db;
use html\figure\figure_list as figure_list_dsp;
use test\test_cleanup;

class figure_list_tests
{

    function run(test_cleanup $t): void
    {

        global $usr;

        // init
        $db_con = new sql_db();
        $sc = new sql();
        $t->name = 'figure->';
        $t->resource_path = 'db/figure/';
        $json_file = 'unit/figure/figure_list_import.json';
        $usr->set_id(1);


        $t->header('Unit tests of the figure list class (src/main/php/model/figure/figure_list.php)');

        $t->subheader('SQL statement creation tests');

        // load by figure ids
        $fig_lst = new figure_list($usr);
        $t->assert_sql_by_ids($db_con, $fig_lst, new fig_ids([1, -1]));


        $t->subheader('API unit tests');

        $fig_lst = $t->dummy_figure_list();
        $t->assert_api($fig_lst);


        $t->subheader('HTML frontend unit tests');

        $fig_lst = $t->dummy_figure_list();
        $t->assert_api_to_dsp($fig_lst, new figure_list_dsp());

    }

}