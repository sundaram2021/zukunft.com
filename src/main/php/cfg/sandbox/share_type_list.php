<?php

/*

    model/sandbox/share_type_list.php - a database based enum list for the data share types
    ---------------------------------


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

    Copyright (c) 1995-2023 zukunft.com AG, Zurich
    Heang Lor <heang@zukunft.com>

    http://zukunft.com

*/

namespace cfg;

use cfg\db\sql_db;

include_once DB_PATH . 'sql_db.php';
include_once MODEL_SANDBOX_PATH . 'share_type.php';

global $share_types;

class share_type_list extends type_list
{

    /**
     * create dummy type list for the unit tests without database connection
     */
    function load_dummy(): void
    {
        $this->reset();
        $type = new type_object(share_type::PUBLIC, share_type::PUBLIC, '', 1);
        $this->add($type);
        $type = new type_object(share_type::PERSONAL, share_type::PERSONAL, '', 2);
        $this->add($type);
        $type = new type_object(share_type::GROUP, share_type::GROUP, '', 3);
        $this->add($type);
        $type = new type_object(share_type::PRIVATE, share_type::PRIVATE, '', 4);
        $this->add($type);
    }

    /**
     * return the database id of the default share type
     */
    function default_id(): int
    {
        return parent::id(share_type::PUBLIC);
    }

}