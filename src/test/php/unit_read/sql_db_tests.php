<?php

/*

    test/php/unit_read/sql_db.php - unit testing of the SQL abstraction layer functions with the current database
    -----------------------------
  

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

namespace unit_read;

use test\test_cleanup;

class sql_db_tests
{

    function run(test_cleanup $t): void
    {

        global $db_con;

        // init
        $t->name = 'sql read db->';

        $t->header('Unit database tests of the SQL abstraction layer class (database/sql_db.php)');

        $t->subheader('Database upgrade functions');

        $result = $db_con->has_column('user_values', 'user_value');
        $t->assert('change_column_name', $result, false);

        $result = $db_con->has_column('user_values', 'numeric_value');
        $t->assert('change_column_name', $result, true);

        $result = $db_con->change_column_name(
            'user_values', 'user_value', 'numeric_value'
        );
        $t->assert('change_column_name', $result, '');

    }

}

