<?php

/*

    api/phrase/term_list.php - a list object of minimal/api term objects
    ------------------------


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

namespace api\phrase;

include_once API_SANDBOX_PATH . 'list_object.php';
include_once API_PHRASE_PATH . 'term.php';
include_once API_PHRASE_PATH . 'term_list.php';
include_once WEB_PHRASE_PATH . 'term_list.php';

use api\sandbox\list_object as list_api;
use html\phrase\term_list as term_list_dsp;;
use JsonSerializable;

class term_list extends list_api implements JsonSerializable
{

    /*
     * construct and map
     */

    function __construct(array $lst = array())
    {
        parent::__construct($lst);
    }

    /**
     * add a term to the list
     * dublicate id is allowed because the phrase and term objects have an extra field for the class
     * @returns bool true if the term has been added
     */
    function add(term $trm): bool
    {
        return parent::add_obj($trm, true);
    }


    /*
     * cast
     */

    /**
     * @returns term_list_dsp the cast object with the HTML code generating functions
     */
    function dsp_obj(): term_list_dsp
    {
        $dsp_obj = new term_list_dsp();

        // cast the single list objects
        $lst_dsp = array();
        foreach ($this->lst() as $trm) {
            if ($trm != null) {
                $phr_dsp = $trm->dsp_obj();
                $lst_dsp[] = $phr_dsp;
            }
        }

        $dsp_obj->set_lst($lst_dsp);
        $dsp_obj->set_lst_dirty();

        return $dsp_obj;
    }

    /*
     * interface
     */

    /**
     * @return string the json api message as a text string
     */
    function get_json(): string
    {
        return json_encode($this->jsonSerialize());
    }

    /**
     * an array of the value vars including the protected vars
     */
    function jsonSerialize(): array
    {
        $vars = [];
        foreach ($this->lst() as $trm) {
            $vars[] = $trm->jsonSerialize();
        }
        return $vars;
    }


    /*
     * modify
     */

    /**
     * removes all terms from this list that are not in the given list
     * @param term_list $new_lst the terms that should remain in this list
     * @returns term_list with the terms of this list and the new list
     */
    function intersect(term_list $new_lst): term_list
    {
        if (!$new_lst->is_empty()) {
            if ($this->is_empty()) {
                $this->set_lst($new_lst->lst());
            } else {
                // next line would work if array_intersect could handle objects
                // $this->lst() = array_intersect($this->lst(), $new_lst->lst());
                $found_lst = new term_list();
                foreach ($new_lst->lst() as $trm) {
                    if (in_array($trm->id(), $this->id_lst())) {
                        $found_lst->add($trm);
                    }
                }
                $this->set_lst($found_lst->lst());
            }
        }
        return $this;
    }

    /**
     * remove all terms from the given list from this list
     * @param term_list $del_lst the terms that should be removed
     * @return term_list this
     */
    function remove(term_list $del_lst): term_list
    {
        if (!$del_lst->is_empty()) {
            // next line would work if array_intersect could handle objects
            // $this->lst() = array_intersect($this->lst(), $new_lst->lst());
            $remain_lst = new term_list();
            foreach ($this->lst() as $trm) {
                if (!in_array($trm->id(), $del_lst->id_lst())) {
                    $remain_lst->add($trm);
                }
            }
            $this->set_lst($remain_lst->lst());
        }
        return $this;
    }

}
