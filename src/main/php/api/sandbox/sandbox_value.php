<?php

/*

    api/user/sandbox_value.php - the minimal superclass for the frontend API
    --------------------------

    This superclass should be used by the classes word_min, formula_min, ... to enable user specific values and links


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

namespace api\sandbox;

include_once API_SANDBOX_PATH . 'sandbox.php';
include_once API_PHRASE_PATH . 'phrase_list.php';
include_once API_PHRASE_PATH . 'group.php';
include_once WEB_PHRASE_PATH . 'phrase_group.php';

use api\sandbox\sandbox as sandbox_api;
use api\phrase\group as group_api;
use api\phrase\phrase_list as phrase_list_api;
use html\phrase\phrase_group as phrase_group_dsp;

class sandbox_value extends sandbox_api
{

    private group_api $grp; // the phrase group with the list of words and triples (not the source words and triples)
    private ?float $number; // the number calculated by the system

    /*
     * construct and map
     */

    function __construct(int|string $id = 0)
    {
        parent::__construct($id);

        $this->grp = new group_api();
        $this->number = null;
    }

    /*
     * set and get
     */

    function id(): int|string
    {
        return $this->id;
    }

    function set_grp(group_api $grp): void
    {
        $this->grp = $grp;
    }

    function set_number(?float $number): void
    {
        $this->number = $number;
    }

    function grp(): group_api
    {
        return $this->grp;
    }

    function number(): ?float
    {
        return $this->number;
    }


    /*
     * cast
     */


    /**
     * @returns phrase_list_api the list of phrases as an object
     */
    function phr_lst(): phrase_list_api
    {
        return $this->grp->phr_lst();
    }

    /**
     * @returns string the html code to display the value with reference links
     * TODO create a popup with the details e.g. the values of other users
     */
    function value_linked(): string
    {
        return $this->number;
    }

    /*
    function load_phrases(): bool
    {
        return $this->grp->load_phrases();
    }
    */

}


