<?php

/*

    value_list_min.php - the minimal value list object
    ------------------


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

namespace api\value;

include_once API_SANDBOX_PATH . 'list_value.php';

use api\sandbox\list_value as list_value_api;
use html\value\value_list as value_list_dsp;

class value_list extends list_value_api
{

    function __construct(array $lst = array())
    {
        parent::__construct($lst);
    }

    /**
     * @returns value_list_dsp the cast object with the HTML code generating functions
     */
    function dsp_obj(): value_list_dsp
    {
        // cast the single list objects
        $lst_dsp = new value_list_dsp();
        foreach ($this->lst() as $val) {
            if ($val != null) {
                $val_dsp = $val->dsp_obj();
                $lst_dsp->add($val_dsp);
            }
        }

        return $lst_dsp;
    }

}
