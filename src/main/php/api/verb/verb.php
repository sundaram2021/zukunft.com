<?php

/*

    api/verb/verb.php - the verb object for the frontend API
    -----------------


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

namespace api\verb;

include_once API_SANDBOX_PATH . 'sandbox_named.php';
include_once MODEL_VERB_PATH . 'verb.php';
include_once WEB_PHRASE_PATH . 'term.php';

use api\phrase\term as term_api;
use api\sandbox\sandbox_named as sandbox_named_api;

class verb extends sandbox_named_api
{

    /*
     * const for system testing
     */

    // already coded verb names or persevered verbs names for unit and integration tests
    // TN_* is the name of the verb
    // TI_* is the database id based on the initial load
    const TN_READ = "not set";
    const TI_READ = 1;
    const TN_IS = "is a";
    const TI_IS = 2;
    const TN_PART = "is part of";
    const TI_PART = 3;
    const TN_OF = "of";
    const TI_OF = 4;
    const TN_TIME_STEP = "time jump";
    const TN_ADD = "System Test Verb";
    const TN_SYMBOL = 'is symbol for';

    // word groups for creating the test words and remove them after the test
    const RESERVED_WORDS = array(
        self::TN_READ,
        self::TN_IS,
        self::TN_PART,
        self::TN_ADD,
    );
    const TEST_WORDS = array(
        self::TN_ADD
    );


    /*
     * cast
     */

    function term(): term_api
    {
        return new term_api($this);
    }

}
