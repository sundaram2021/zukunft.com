<?php

/*

    api/word/word_list.php - a list object of minimal/api word objects
    ----------------------


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

namespace api\word;

include_once API_SANDBOX_PATH . 'list_object.php';
include_once SHARED_TYPES_PATH . 'phrase_type.php';

use api\word\word as word_api;
use api\sandbox\list_object as list_api;
use cfg\phrase_type;
use html\word\word_list as word_list_dsp;
use shared\types\phrase_type AS phrase_type_shared;

class word_list extends list_api
{

    /*
     * construct and map
     */

    function __construct(array $lst = array())
    {
        parent::__construct($lst);
    }

    /**
     * add a word to the list
     * @returns bool true if the word has been added
     */
    function add(word_api $wrd): bool
    {
        return parent::add_obj($wrd);
    }


    /*
     * cast
     */

    /**
     * @returns word_list_dsp the cast object with the HTML code generating functions
     */
    function dsp_obj(): word_list_dsp
    {
        $dsp_obj = new word_list_dsp();

        // cast the single list objects
        $lst_dsp = array();
        foreach ($this->lst() as $wrd) {
            if ($wrd != null) {
                $wrd_dsp = $wrd->dsp_obj();
                $lst_dsp[] = $wrd_dsp;
            }
        }

        $dsp_obj->set_lst($lst_dsp);
        $dsp_obj->set_lst_dirty();

        return $dsp_obj;
    }


    /*
     * selection functions
     */

    /**
     * diff as a function, because the array_diff does not seem to work for an object list
     *
     * e.g. for "2014", "2015", "2016", "2017"
     * and delete list of "2016", "2017","2018"
     * the result is "2014", "2015"
     *
     * @param word_list $del_lst is the list of phrases that should be removed from this list object
     */
    private function diff(word_list $del_lst): void
    {
        if (!$this->is_empty()) {
            $result = array();
            $lst_ids = $del_lst->id_lst();
            foreach ($this->lst() as $wrd) {
                if (!in_array($wrd->id(), $lst_ids)) {
                    $result[] = $wrd;
                }
            }
            $this->set_lst($result);
        }
    }

    /**
     * merge as a function, because the array_merge does not create an object
     * @param word_list $new_wrd_lst with the words that should be added
     */
    function merge(word_list $new_wrd_lst): void
    {
        foreach ($new_wrd_lst->lst() as $new_wrd) {
            $this->add($new_wrd);
        }
    }

    /**
     * @param string $type the ENUM string of the fixed type
     * @return word_list with the all words of the give type
     */
    private function filter(string $type): word_list
    {
        $result = new word_list();
        foreach ($this->lst() as $wrd) {
            if ($wrd->is_type($type)) {
                $result->add($wrd);
            }
        }
        return $result;
    }

    /**
     * get all time words from this list of words
     */
    function time_lst(): word_list
    {
        return $this->filter(phrase_type_shared::TIME);
    }

    /**
     * get all measure words from this list of words
     */
    function measure_lst(): word_list
    {
        return $this->filter(phrase_type_shared::MEASURE);
    }

    /**
     * get all scaling words from this list of words
     */
    function scaling_lst(): word_list
    {
        $result = new word_list();
        foreach ($this->lst() as $wrd) {
            if ($wrd->is_scaling()) {
                $result->add($wrd);
            }
        }
        return $result;
    }

    /**
     * get all measure and scaling words from this list of words
     * @returns word_list words that are usually shown after a number
     */
    function measure_scale_lst(): word_list
    {
        $scale_lst = $this->scaling_lst();
        $measure_lst = $this->measure_lst();
        $measure_lst->merge($scale_lst);
        return $measure_lst;
    }

    /**
     * get all measure words from this list of words
     */
    function percent_lst(): word_list
    {
        return $this->filter(phrase_type_shared::PERCENT);
    }

    /**
     * like names_linked, but without measure and time words
     * because measure words are usually shown after the number
     * TODO call this from the display object t o avoid casting again
     * @returns word_list a word
     */
    function ex_measure_and_time_lst(): word_list
    {
        $wrd_lst_ex = clone $this;
        $wrd_lst_ex->ex_time();
        $wrd_lst_ex->ex_measure();
        $wrd_lst_ex->ex_scaling();
        $wrd_lst_ex->ex_percent(); // the percent sign is normally added to the value
        return $wrd_lst_ex;
    }

    /**
     * Exclude all time words from this word list
     */
    function ex_time(): void
    {
        $this->diff($this->time_lst());
    }

    /**
     * Exclude all measure words from this word list
     */
    function ex_measure(): void
    {
        $this->diff($this->measure_lst());
    }

    /**
     * Exclude all measure words from this word list
     */
    function ex_scaling(): void
    {
        $this->diff($this->scaling_lst());
    }

    /**
     * Exclude all measure words from this word list
     */
    function ex_percent(): void
    {
        $this->diff($this->percent_lst());
    }

}
