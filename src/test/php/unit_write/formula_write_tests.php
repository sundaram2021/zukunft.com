<?php

/*

    test/php/unit_write/formula_tests.php - write test FORMULAS to the database and check the results
    -------------------------------------
  

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

namespace unit_write;

use api\formula\formula as formula_api;
use api\result\result as result_api;
use api\word\word as word_api;
use cfg\formula_list;
use cfg\formula_type;
use cfg\word;
use html\formula\formula as formula_dsp;
use cfg\log\change_field_list;
use cfg\log\change;
use cfg\log\change_table_list;
use cfg\formula;
use cfg\phrase_list;
use cfg\sandbox_named;
use test\test_cleanup;

class formula_write_tests
{

    function run(test_cleanup $t): void
    {

        global $formula_types;

        // init
        $t->name = 'formula->';
        $back = 0;

        $t->header('formula db write tests');

        $t->subheader('formula prepared write');
        $test_name = 'add formula ' . formula_api::TN_ADD_VIA_SQL . ' via sql insert';
        $t->assert_write_via_func_or_sql($test_name, $t->formula_add_by_sql(), false);
        $test_name = 'add formula ' . formula_api::TN_ADD_VIA_FUNC . ' via sql function';
        $t->assert_write_via_func_or_sql($test_name, $t->formula_add_by_func(), true);

        // test loading of one formula
        $frm = new formula($t->usr1);
        $frm->load_by_name(formula_api::TN_ADD, formula::class);
        $result = $frm->usr_text;
        $target = formula_api::TF_INCREASE;
        $t->assert('load for "' . $frm->name() . '"', $result, $target);

        // test the formula type
        $result = zu_dsp_bool($frm->is_special());
        $target = zu_dsp_bool(false);
        $t->display('formula->is_special for "' . $frm->name() . '"', $target, $result);

        $exp = $frm->expression();
        $frm_lst = $exp->element_special_following_frm();
        $phr_lst = new phrase_list($t->usr1);
        if (!$frm_lst->is_empty()) {
            if (count($frm_lst->lst()) > 0) {
                $elm_frm = $frm_lst->lst()[0];
                $result = zu_dsp_bool($elm_frm->is_special());
                $target = zu_dsp_bool(true);
                $t->display('formula->is_special for "' . $elm_frm->name() . '"', $target, $result);

                $phr_lst->load_by_names(array(word_api::TN_CH, word_api::TN_INHABITANTS, word_api::TN_2019));
                $time_phr = $phr_lst->time_useful();
                $val = $elm_frm->special_result($phr_lst, $time_phr);
                $result = $val->number();
                $target = word_api::TN_2019;
                // TODO: get the best matching number
                //$t->display('formula->special_result for "'.$elm_frm->name.'"', $target, $result);

                if (count($frm_lst->lst()) > 1) {
                    //$elm_frm_next = $frm_lst->lst[1];
                    $elm_frm_next = $elm_frm;
                } else {
                    $elm_frm_next = $elm_frm;
                }
                $time_phr = $elm_frm_next->special_time_phr($time_phr);
                $result = $time_phr->name();
                $target = word_api::TN_2019;
                $t->display('formula->special_time_phr for "' . $elm_frm_next->name() . '"', $target, $result);
            }
        }

        $phr_lst = $frm->special_phr_lst($phr_lst);
        if (!isset($phr_lst)) {
            $result = '';
        } else {
            $result = $phr_lst->name();
        }
        $target = '"' . word_api::TN_2019 . '","' . word_api::TN_CH . '","' . word_api::TN_INHABITANTS . '"';
        $t->display('formula->special_phr_lst for "' . $frm->name() . '"', $target, $result);

        $phr_lst = $frm->assign_phr_lst_direct();
        if (!isset($phr_lst)) {
            $result = '';
        } else {
            $result = $phr_lst->dsp_name();
        }
        $target = '"Year"';
        $t->display('formula->assign_phr_lst_direct for "' . $frm->name() . '"', $target, $result);

        $phr_lst = $frm->assign_phr_ulst_direct();
        if (!isset($phr_lst)) {
            $result = '';
        } else {
            $result = $phr_lst->dsp_name();
        }
        $target = '"Year"';
        $t->display('formula->assign_phr_ulst_direct for "' . $frm->name() . '"', $target, $result);

        // loading another formula (Price Earning ratio ) to have more test cases
        $frm_pe = $t->load_formula(formula_api::TN_RATIO);

        $wrd_share = $t->test_word(word_api::TN_SHARE);
        $wrd_chf = $t->test_word(word_api::TWN_CHF);

        $frm_pe->assign_phrase($wrd_share->phrase());

        $phr_lst = new phrase_list($t->usr1);
        $phr_lst->load_by_names(array(word_api::TN_SHARE, word_api::TWN_CHF));

        $phr_lst_all = $frm_pe->assign_phr_lst();
        $phr_lst = $phr_lst_all->del_list($phr_lst);
        $result = $phr_lst->dsp_name();
        $target = '"' . word_api::TN_SHARE . '"';
        $t->display('formula->assign_phr_lst for "' . $frm->name() . '"', $target, $result);

        $phr_lst_all = $frm_pe->assign_phr_ulst();
        $phr_lst = $phr_lst_all->del_list($phr_lst);
        $result = $phr_lst->dsp_name();
        $target = '"' . word_api::TN_SHARE . '"';
        $t->display('formula->assign_phr_ulst for "' . $frm->name() . '"', $target, $result);

        // test the calculation of one value
        $phr_lst = new phrase_list($t->usr1);
        // TODO check why is this word MIO is needed??
        $phr_lst->load_by_names(array(word_api::TN_CH, word_api::TN_INHABITANTS, word_api::TN_2020, word_api::TN_MIO));
        $frm = $t->load_formula(formula_api::TN_ADD);
        $res_lst = $frm->to_num($phr_lst);
        if ($res_lst->lst() != null) {
            $res = $res_lst->lst()[0];
            $result = $res->num_text;
        } else {
            $res = null;
            $result = 'result list is empty';
        }
        $target = '=(8.505251-8.438822)/8.438822';
        $t->display('formula->to_num "' . $frm->name() . '" for a tern list ' . $phr_lst->dsp_id(), $target, $result);

        if ($res_lst->lst() != null) {
            $res->save_if_updated();
            $result = $res->number();
            $target = result_api::TV_INCREASE_LONG;
            $t->display('result->save_if_updated "' . $frm->name() . '" for a tern list ' . $phr_lst->dsp_id(), $target, $result);
        }

        $res_lst = $frm->calc($phr_lst);
        if ($res_lst != null) {
            $result = $res_lst[0]->number();
        } else {
            $result = '';
        }
        $target = result_api::TV_INCREASE_LONG;
        $t->display('formula->calc "' . $frm->name() . '" for a tern list ' . $phr_lst->dsp_id(), $target, $result);

        // test the scaling mainly to check the scaling handling of the results later
        // TODO remove any scaling words from the phrase list if the result word is of type scaling
        // TODO automatically check the fastest way to scale and avoid double scaling calculations
        $frm_scale_mio_to_one = $t->load_formula(formula_api::TN_SCALE_MIO);
        $res_lst = $frm_scale_mio_to_one->calc($phr_lst);
        if ($res_lst != null) {
            $result = $res_lst[0]->number();
        } else {
            $result = '';
        }
        $target = '8505251.0';
        $t->display('formula->calc "' . $frm->name() . '" for a tern list ' . $phr_lst->dsp_id(), $target, $result);

        // test the scaling back to a thousand
        $phr_lst = new phrase_list($t->usr1);
        // TODO check why is this word ONE needed?? scale shout assume one if no scaling word is set or implied
        //$phr_lst->load_by_names(array(word_api::TN_CH, word_api::TN_INHABITANTS, word_api::TN_2020));
        $phr_lst->load_by_names(array(word_api::TN_CH, word_api::TN_INHABITANTS, word_api::TN_2020, word_api::TN_ONE));
        $frm_scale_one_to_k = $t->load_formula(formula_api::TN_SCALE_TO_K);
        // TODO activate Prio 1
        //$res_lst = $frm_scale_one_to_k->calc($phr_lst);
        if ($res_lst != null) {
            $result = $res_lst[0]->number();
        } else {
            $result = '';
        }
        $target = 8505.251;
        // TODO activate Prio 1
        //$t->display('formula->calc "' . $frm->name() . '" for a tern list ' . $phr_lst->dsp_id(), $target, $result);

        // load the test ids
        $wrd_percent = $t->load_word('percent');
        $frm_this = $t->load_formula(formula_api::TN_READ_THIS);
        $frm_prior = $t->load_formula(formula_api::TN_READ_PRIOR);

        // test the formula display functions
        $frm = $t->load_formula(formula_api::TN_ADD);
        $frm_html = new formula_dsp($frm->api_json());
        $exp = $frm->expression();
        $result = $exp->dsp_id();
        $target = '""percent" = ( "this" - "prior" ) / "prior"" ({w' . $wrd_percent->id() . '}=({f' . $frm_this->id() . '}-{f' . $frm_prior->id() . '})/{f' . $frm_prior->id() . '})';
        $t->display('formula->expression for ' . $frm->dsp_id(), $target, $result);

        // ... the formula name
        $result = $frm->name();
        $target = 'System Test Formula';
        $t->display('formula->name for ' . $frm->dsp_id(), $target, $result);

        // ... in HTML format
        $result = $frm_html->dsp_text($back);
        $target = '"percent" = ( <a href="/http/formula_edit.php?id=' . $frm_this->id() . '&back=0" title="this">this</a> - <a href="/http/formula_edit.php?id=' . $frm_prior->id() . '&back=0" title=<a href="/http/formula_edit.php?id=20&back=0" title="prior">prior</a>>prior</a> ) / <a href="/http/formula_edit.php?id=20&back=0" title=<a href="/http/formula_edit.php?id=' . $frm_prior->id() . '&back=0" title="prior">prior</a>>prior</a>';
        $t->display('formula->dsp_text for ' . $frm->dsp_id(), $target, $result);

        // ... in HTML format with link
        $frm_increase = $t->load_formula(formula_api::TN_ADD);
        $result = $frm_html->edit_link($back);
        $target = '<a href="/http/formula_edit.php?id=' . $frm_increase->id() . '&back=0" title="' . formula_api::TN_ADD . '">' . formula_api::TN_ADD . '</a>';
        $t->display('formula->display for ' . $frm->dsp_id(), $target, $result);

        // ... the formula result selected by the word and in percent
        // TODO defined the criteria for selecting the result
        $wrd = new word($t->usr1);
        $wrd->load_by_name(word_api::TN_CH);
        /*
        $result = trim($frm_dsp->dsp_result($wrd, $back));
        $target = '0.79 %';
        $t->display('formula->dsp_result for ' . $frm->dsp_id() . ' and ' . $wrd->name(), $target, $result);
        */

        /* TODO reactivate
        $result = $frm->btn_edit();
        $target = '<a href="/http/formula_edit.php?id=52&back=" title="Change formula increase"><img src="/src/main/resources/images/button_edit.svg" alt="Change formula increase"></a>';
        $target = 'data-icon="edit"';
        $t->dsp_contains(', formula->btn_edit for '.$frm->name().'', $target, $result);
        */

        $page = 1;
        $size = 20;
        $call = '/http/test.php';
        $result = $frm_html->dsp_hist($page, $size, $call, $back);
        $target = 'changed to';
        $t->dsp_contains(', formula->dsp_hist for ' . $frm->dsp_id() . '', $target, $result);

        $result = $frm_html->dsp_hist_links($page, $size, $call, $back);
        // TODO fix it
        //$target = 'link';
        $target = 'table';
        //$result = $hist_page;
        $t->dsp_contains(', formula->dsp_hist_links for ' . $frm->dsp_id() . '', $target, $result);

        $add = 0;
        $result = $frm_html->dsp_edit($add, $wrd, $back);
        $target = 'Formula "System Test Formula"';
        //$result = $edit_page;
        $t->dsp_contains(', formula->dsp_edit for ' . $frm->dsp_id(), $target, $result, $t::TIMEOUT_LIMIT_PAGE);

        // test formula refresh functions

        $result = $frm->element_refresh($frm->ref_text);
        $target = true;
        $t->display('formula->element_refresh for ' . $frm->dsp_id(), $target, $result);


        // to link and unlink a formula is tested in the formula_link section

        // test adding of one formula
        $frm = new formula($t->usr1);
        $frm->set_name(formula_api::TN_ADD);
        $frm->usr_text = formula_api::TF_INCREASE;
        $result = $frm->save();
        if ($frm->id() > 0) {
            $result = $frm->usr_text;
        }
        $target = formula_api::TF_INCREASE;
        $t->display('formula->save for adding "' . $frm->name() . '"', $target, $result, $t::TIMEOUT_LIMIT_DB_MULTI);

        // check if the formula name has been saved
        $frm = $t->load_formula(formula_api::TN_ADD);
        $result = $frm->usr_text;
        $target = formula_api::TF_INCREASE;
        $t->display('formula->load the added "' . $frm->name() . '"', $target, $result, $t::TIMEOUT_LIMIT_DB_MULTI); // time limit???

        // ... check the correct logging
        $log = new change($t->usr1);
        $log->set_table(change_table_list::FORMULA);
        $log->set_field(change_field_list::FLD_FORMULA_NAME);
        $log->row_id = $frm->id();
        $result = $log->dsp_last(true);
        $target = 'zukunft.com system test added "System Test Formula"';
        $t->display('formula->save adding logged for "' . formula_api::TN_ADD . '"', $target, $result);

        // check if adding the same formula again creates a correct error message
        $frm = new formula($t->usr1);
        $frm->set_name(formula_api::TN_ADD);
        $frm->usr_text = formula_api::TF_INCREASE_ALTERNATIVE;
        $result = $frm->save();
        // use the next line if system config is non-standard
        //$target = 'A formula with the name "'.formula_api::TN_ADD.'" already exists. Please use another name.';
        $target = '';
        $t->display('formula->save adding "' . $frm->name() . '" again', $target, $result, $t::TIMEOUT_LIMIT_DB_MULTI);

        // check if the formula can be renamed
        $frm = $t->load_formula(formula_api::TN_ADD);
        $frm->set_name(formula_api::TN_RENAMED);
        $result = $frm->save();
        $target = '';
        $t->display('formula->save rename "' . formula_api::TN_ADD . '" to "' . formula_api::TN_RENAMED . '".', $target, $result, $t::TIMEOUT_LIMIT_DB_MULTI);

        // ... and if the formula renaming was successful
        $frm_renamed = new formula($t->usr1);
        $frm_renamed->load_by_name(formula_api::TN_RENAMED, formula::class);
        if ($frm_renamed->id() > 0) {
            $result = $frm_renamed->name();
        }
        $target = formula_api::TN_RENAMED;
        $t->display('formula->load renamed formula "' . formula_api::TN_RENAMED . '"', $target, $result);

        // ... and if the formula renaming has been logged
        $log = new change($t->usr1);
        $log->set_table(change_table_list::FORMULA);
        $log->set_field(change_field_list::FLD_FORMULA_NAME);
        $log->row_id = $frm_renamed->id();
        $result = $log->dsp_last(true);
        $target = 'zukunft.com system test changed "System Test Formula" to "System Test Formula Renamed"';
        $t->display('formula->save rename logged for "' . formula_api::TN_RENAMED . '"', $target, $result);

        // check if the formula parameters can be added
        $frm_renamed->usr_text = '= "this"';
        $frm_renamed->description = formula_api::TN_RENAMED . ' description';
        $frm_renamed->type_id = $formula_types->id(formula_type::THIS);
        $frm_renamed->need_all_val = True;
        $result = $frm_renamed->save();
        $target = '';
        $t->display('formula->save all formula fields beside the name for "' . formula_api::TN_RENAMED . '"', $target, $result, $t::TIMEOUT_LIMIT_DB_MULTI);

        // ... and if the formula parameters have been added
        $frm_reloaded = $t->load_formula(formula_api::TN_RENAMED);
        $result = $frm_reloaded->usr_text;
        $target = '= "this"';
        $t->display('formula->load usr_text for "' . formula_api::TN_RENAMED . '"', $target, $result);
        $result = $frm_reloaded->ref_text;
        $target = '={f' . $frm_this->id() . '}';
        $t->display('formula->load ref_text for "' . formula_api::TN_RENAMED . '"', $target, $result);
        $result = $frm_reloaded->description;
        $target = formula_api::TN_RENAMED . ' description';
        $t->display('formula->load description for "' . formula_api::TN_RENAMED . '"', $target, $result);
        $result = $frm_reloaded->type_id;
        $target = $formula_types->id(formula_type::THIS);
        $t->display('formula->load type_id for "' . formula_api::TN_RENAMED . '"', $target, $result);
        $result = $frm_reloaded->need_all_val;
        $target = True;
        $t->display('formula->load need_all_val for "' . formula_api::TN_RENAMED . '"', $target, $result);

        // ... and if the formula parameter adding have been logged
        $log = new change($t->usr1);
        $log->set_table(change_table_list::FORMULA);
        $log->set_field(change_field_list::FLD_FORMULA_USR_TEXT);
        $log->row_id = $frm_reloaded->id();
        $result = $log->dsp_last(true);
        // use the next line if system config is non-standard
        $target = 'zukunft.com system test changed "percent" = ( "this" - "prior" ) / "prior" to = "this"';
        $target = 'zukunft.com system test changed ""percent" = 1 - ( "this" / "prior" )" to "= "this""';
        $t->display('formula->load resolved_text for "' . formula_api::TN_RENAMED . '" logged', $target, $result);
        $log->set_field(change_field_list::FLD_FORMULA_REF_TEXT);
        $result = $log->dsp_last(true);
        // use the next line if system config is non-standard
        $target = 'zukunft.com system test changed {w' . $wrd_percent->id() . '}=( {f' . $frm_this->id() . '} - {f5} ) / {f5} to ={f3}';
        $target = 'zukunft.com system test changed "{w' . $wrd_percent->id() . '}=1-({f' . $frm_this->id() . '}/{f' . $frm_prior->id() . '})" to "={f' . $frm_this->id() . '}"';
        $t->display('formula->load formula_text for "' . formula_api::TN_RENAMED . '" logged', $target, $result);
        $log->set_field(sandbox_named::FLD_DESCRIPTION);
        $result = $log->dsp_last(true);
        $target = 'zukunft.com system test added "System Test Formula Renamed description"';
        $t->display('formula->load description for "' . formula_api::TN_RENAMED . '" logged', $target, $result);
        $log->set_field(change_field_list::FLD_FORMULA_TYPE);
        $result = $log->dsp_last(true);
        // to review what is correct
        $target = 'zukunft.com system test changed calc to this';
        $target = 'zukunft.com system test added "this"';
        $t->display('formula->load formula_type_id for "' . formula_api::TN_RENAMED . '" logged', $target, $result);
        $log->set_field(change_field_list::FLD_FORMULA_ALL);
        $result = $log->dsp_last(true);
        $target = 'zukunft.com system test changed "0" to "1"';
        $t->display('formula->load all_values_needed for "' . formula_api::TN_RENAMED . '" logged', $target, $result);

        // check if a user specific formula is created if another user changes the formula
        $frm_usr2 = new formula($t->usr2);
        $frm_usr2->load_by_name(formula_api::TN_RENAMED, formula::class);
        $frm_usr2->usr_text = '"percent" = ( "this" - "prior" ) / "prior"';
        $frm_usr2->description = formula_api::TN_RENAMED . ' description2';
        $frm_usr2->type_id = $formula_types->id(formula_type::NEXT);
        $frm_usr2->need_all_val = False;
        $result = $frm_usr2->save();
        $target = '';
        $t->display('formula->save all formula fields for user 2 beside the name for "' . formula_api::TN_RENAMED . '"', $target, $result, $t::TIMEOUT_LIMIT_DB_MULTI);

        // ... and if a user specific formula changes have been saved
        $frm_usr2_reloaded = new formula($t->usr2);
        $frm_usr2_reloaded->load_by_name(formula_api::TN_RENAMED, formula::class);
        $result = $frm_usr2_reloaded->usr_text;
        $target = '"percent" = ( "this" - "prior" ) / "prior"';
        $t->display('formula->load usr_text for "' . formula_api::TN_RENAMED . '"', $target, $result);
        $result = $frm_usr2_reloaded->ref_text;
        $target = '{w' . $wrd_percent->id() . '}=({f' . $frm_this->id() . '}-{f' . $frm_prior->id() . '})/{f' . $frm_prior->id() . '}';
        $t->display('formula->load ref_text for "' . formula_api::TN_RENAMED . '"', $target, $result);
        $result = $frm_usr2_reloaded->description;
        $target = formula_api::TN_RENAMED . ' description2';
        $t->display('formula->load description for "' . formula_api::TN_RENAMED . '"', $target, $result);
        $result = $frm_usr2_reloaded->type_id;
        $target = $formula_types->id(formula_type::NEXT);
        $t->display('formula->load type_id for "' . formula_api::TN_RENAMED . '"', $target, $result);
        $result = $frm_usr2_reloaded->need_all_val;
        $target = False;
        $t->display('formula->load need_all_val for "' . formula_api::TN_RENAMED . '"', $target, $result);

        // ... and the formula for the original user remains unchanged
        $frm_reloaded = $t->load_formula(formula_api::TN_RENAMED);
        $result = $frm_reloaded->usr_text;
        $target = '= "this"';
        $t->display('formula->load usr_text for "' . formula_api::TN_RENAMED . '"', $target, $result);
        $result = $frm_reloaded->ref_text;
        $target = '={f' . $frm_this->id() . '}';
        $t->display('formula->load ref_text for "' . formula_api::TN_RENAMED . '"', $target, $result);
        $result = $frm_reloaded->description;
        $target = formula_api::TN_RENAMED . ' description';
        $t->display('formula->load description for "' . formula_api::TN_RENAMED . '"', $target, $result);
        $result = $frm_reloaded->type_id;
        $target = $formula_types->id(formula_type::THIS);
        $t->display('formula->load type_id for "' . formula_api::TN_RENAMED . '"', $target, $result);
        $result = $frm_reloaded->need_all_val;
        $target = True;
        $t->display('formula->load need_all_val for "' . formula_api::TN_RENAMED . '"', $target, $result);

        // check if undo all specific changes removes the user formula
        $frm_usr2 = new formula($t->usr2);
        $frm_usr2->load_by_name(formula_api::TN_RENAMED, formula::class);
        $frm_usr2->usr_text = '= "this"';
        $frm_usr2->description = formula_api::TN_RENAMED . ' description';
        $frm_usr2->type_id = $formula_types->id(formula_type::THIS);
        $frm_usr2->need_all_val = True;
        $result = $frm_usr2->save();
        $target = '';
        $t->display('formula->save undo the user formula fields beside the name for "' . formula_api::TN_RENAMED . '"', $target, $result, $t::TIMEOUT_LIMIT_DB_MULTI);

        // ... and if a user specific formula changes have been saved
        $frm_usr2_reloaded = new formula($t->usr2);
        $frm_usr2_reloaded->load_by_name(formula_api::TN_RENAMED, formula::class);
        $result = $frm_usr2_reloaded->usr_text;
        $target = '= "this"';
        $t->display('formula->load usr_text for "' . formula_api::TN_RENAMED . '"', $target, $result);
        $result = $frm_usr2_reloaded->ref_text;
        $target = '={f' . $frm_this->id() . '}';
        $t->display('formula->load ref_text for "' . formula_api::TN_RENAMED . '"', $target, $result);
        $result = $frm_usr2_reloaded->description;
        $target = formula_api::TN_RENAMED . ' description';
        $t->display('formula->load description for "' . formula_api::TN_RENAMED . '"', $target, $result);
        $result = $frm_usr2_reloaded->type_id;
        $target = $formula_types->id(formula_type::THIS);
        $t->display('formula->load type_id for "' . formula_api::TN_RENAMED . '"', $target, $result);
        $result = $frm_usr2_reloaded->need_all_val;
        $target = True;
        $t->display('formula->load need_all_val for "' . formula_api::TN_RENAMED . '"', $target, $result);

        // redo the user specific formula changes
        // check if the user specific changes can be removed with one click

        // check for formulas also that

        // TODO check if the word assignment can be done for each user

    }

    function run_list(test_cleanup $t): void
    {

        $t->header('est the formula list class (classes/formula_list.php)');

        // load the main test word
        $wrd_share = $t->test_word(word_api::TN_SHARE);

        $wrd = new word($t->usr1);
        $wrd->load_by_id($wrd_share->id(), word::class);
        $frm_lst = new formula_list($t->usr1);
        $frm_lst->back = $wrd->id();
        $frm_lst->load_by_phr($wrd->phrase());
        // TODO fix it
        //$result = $frm_lst->display();
        //$target = formula_api::TN_RATIO;
        // $t->dsp_contains(', formula_list->load formula for word "' . $wrd->dsp_id() . '" should contain', $target, $result, $t::TIMEOUT_LIMIT_PAGE);

    }

    function create_test_formulas(test_cleanup $t): void
    {
        $t->header('Check if all base formulas are correct');

        $t->test_word(word_api::TN_EARNING);
        $t->test_word(word_api::TN_PRICE);
        $t->test_word(word_api::TN_PE);
        $t->test_formula(formula_api::TN_RATIO, formula_api::TF_RATIO);
        $t->test_word(word_api::TN_TOTAL);
        $t->test_formula(formula_api::TN_SECTOR, formula_api::TF_SECTOR);
        //$t->test_formula(formula_api::TN_THIS, formula_api::TF_THIS);
        $t->test_word(word_api::TN_THIS);
        $t->test_word(word_api::TN_PRIOR);
        $t->test_formula(formula_api::TN_ADD, formula_api::TF_INCREASE);
        $t->test_formula(formula_api::TN_EXCLUDED, formula_api::TF_INCREASE);
        $t->test_word(word_api::TN_IN_K);
        $t->test_word(word_api::TN_BIL);
        $t->test_formula(formula_api::TN_SCALE_K, formula_api::TF_SCALE_K);
        $t->test_formula(formula_api::TN_SCALE_TO_K, formula_api::TF_SCALE_TO_K);
        $t->test_formula(formula_api::TN_SCALE_MIO, formula_api::TF_SCALE_MIO);
        $t->test_formula(formula_api::TN_SCALE_BIL, formula_api::TF_SCALE_BIL);

        // modify the special test cases
        global $usr;
        $frm = new formula($usr);
        $frm->load_by_name(formula_api::TN_EXCLUDED);
        if ($frm->name() == '') {
            log_err('formula ' . formula_api::TN_EXCLUDED . ' could not be loaded');
        } else {
            $frm->set_excluded(true);
            $frm->save();
        }
    }


}