<?php

/*

  api/component/index.php - the component API controller: send a component component to the frontend
  -----------------------
  
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

// standard zukunft header for callable php files to allow debugging and lib loading
global $debug;
$debug = $_GET['debug'] ?? 0;
const ROOT_PATH = __DIR__ . DIRECTORY_SEPARATOR . '..' . DIRECTORY_SEPARATOR . '..' . DIRECTORY_SEPARATOR;
const PHP_PATH = ROOT_PATH . 'src' . DIRECTORY_SEPARATOR . 'main' . DIRECTORY_SEPARATOR . 'php' . DIRECTORY_SEPARATOR;
include_once PHP_PATH . 'zu_lib.php';

include_once SHARED_PATH . 'api.php';
include_once API_PATH . 'controller.php';
include_once API_PATH . 'api_message.php';
include_once MODEL_USER_PATH . 'user.php';
include_once MODEL_COMPONENT_PATH . 'component.php';
include_once API_VIEW_PATH . 'view_cmp.php';

use api\component\component as component_api;
use cfg\component\component;
use cfg\user\user;
use controller\controller;
use shared\api;

// open database
$db_con = prg_start("api/component", "", false);

// get the parameters
$cmp_id = $_GET[api::URL_VAR_ID] ?? 0;
$cmp_name = $_GET[api::URL_VAR_NAME] ?? '';

$msg = '';
$result = new component_api(); // reset the html code var

// load the session user parameters
$usr = new user;
$msg .= $usr->get();

// check if the user is permitted (e.g. to exclude crawlers from doing stupid stuff)
if ($usr->id() > 0) {

    $cmp = new component($usr);
    if ($cmp_id > 0) {
        $cmp->load_by_id($cmp_id);
        $result = $cmp->api_obj();
    } elseif ($cmp_name != '') {
        $cmp->load_by_name($cmp_name);
        $result = $cmp->api_obj();
    } else {
        $msg = 'component id or name is missing';
    }
}

$ctrl = new controller();
$ctrl->get($result, $msg);


prg_end_api($db_con);
