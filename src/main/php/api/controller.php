<?php

/*

    controller.php - the base class for API controller
    --------------

    includes all const for the API


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

namespace controller;

include_once API_PATH . 'api_message.php';
include_once API_SYSTEM_PATH . 'type_lists.php';
include_once API_SANDBOX_PATH . 'combine_object.php';
include_once API_SANDBOX_PATH . 'list_object.php';
include_once API_SANDBOX_PATH . 'sandbox.php';
include_once MODEL_USER_PATH . 'user.php';
include_once MODEL_REF_PATH . 'source.php';
include_once MODEL_WORD_PATH . 'word.php';

use api\api_message;
use api\sandbox\combine_object as combine_object_api;
use api\sandbox\list_object as list_api;
use api\system\type_lists as type_lists_api;
use api\sandbox\sandbox as sandbox_api;
use cfg\combine_object;
use cfg\sandbox;
use cfg\source;
use cfg\word;

class controller
{

    /*
     * URL
     */

    // the parameter names used in the url or in the result json
    const URL_API_PATH = 'api/';
    const URL_VAR_ID = 'id'; // the internal database id that should never be shown to the user
    const URL_VAR_ID_LST = 'ids'; // a comma seperated list of internal database ids
    const URL_VAR_NAME = 'name'; // the unique name of a term, view, component, user, source, language or type
    const URL_VAR_PATTERN = 'pattern'; // part of a name to select a named object such as word, triple, ...
    const URL_VAR_COMMENT = 'comment';
    const URL_VAR_DESCRIPTION = 'description';
    const URL_VAR_DEBUG = 'debug'; // to force the output of debug messages
    const URL_VAR_CODE_ID = 'code_id';
    const URL_VAR_WORD = 'words';
    const URL_VAR_PHRASE = 'phrase'; // the id (or name?) of one phrase
    const URL_VAR_DIRECTION = 'dir'; // 'up' to get the parents and 'down' for the children
    const URL_VAR_LEVELS = 'levels'; // the number of search levels'
    const URL_VAR_MSG = 'message';
    const URL_VAR_RESULT = 'result';
    const URL_VAR_EMAIL = 'email';
    const URL_VAR_VIEW_ID = 'view_id';
    const URL_VAR_COMPONENT_ID = 'component_id';

    // used for the change log
    const URL_VAR_WORD_ID = 'word_id';
    const URL_VAR_WORD_FLD = 'word_field';
    const URL_VAR_LINK_PHRASE = 'link_phrase';
    const URL_VAR_UNLINK_PHRASE = 'unlink_phrase';


    /*
     * API
     */

    // json field names of the api json messages


    const API_BODY = 'body';
    const API_BODY_SYS_LOG = 'sys_log';

    // to include the objects that should be displayed in one api message
    const API_WORD = 'word';
    const API_TRIPLE = 'triple';

    //
    const API_TYPE_LISTS = 'type_lists';
    const API_LIST_USER_PROFILES = 'user_profiles';
    const API_LIST_PHRASE_TYPES = 'phrase_types';
    const API_LIST_FORMULA_TYPES = 'formula_types';
    const API_LIST_FORMULA_LINK_TYPES = 'formula_link_types';
    const API_LIST_ELEMENT_TYPES = 'element_types';
    const API_LIST_VIEW_TYPES = 'view_types';
    const API_LIST_VIEW_LINK_TYPES = 'view_link_types';
    const API_LIST_COMPONENT_TYPES = 'component_types';
    // const API_LIST_COMPONENT_LINK_TYPES = 'component_link_types';
    const API_LIST_COMPONENT_POSITION_TYPES = 'position_types';
    const API_LIST_REF_TYPES = 'ref_types';
    const API_LIST_SOURCE_TYPES = 'source_types';
    const API_LIST_SHARE_TYPES = 'share_types';
    const API_LIST_PROTECTION_TYPES = 'protection_types';
    const API_LIST_LANGUAGES = 'languages';
    const API_LIST_LANGUAGE_FORMS = 'language_forms';
    const API_LIST_SYS_LOG_STATI = 'sys_log_stati';
    const API_LIST_JOB_TYPES = 'job_types';
    const API_LIST_CHANGE_LOG_ACTIONS = 'change_action_list';
    const API_LIST_CHANGE_LOG_TABLES = 'change_table_list';
    const API_LIST_CHANGE_LOG_FIELDS = 'change_field_list';
    const API_LIST_VERBS = 'verbs';
    const API_LIST_SYSTEM_VIEWS = 'system_views';
    const API_BACK = 'back'; // to include the url that should be call after an action has been finished into the url

    // path parameters
    const PATH_API_REDIRECT = '/../../'; // get from the __DIR__ to the php root path
    const PATH_MAIN_LIB = 'src/main/php/zu_lib.php'; // the main php library the contains all other paths


    /*
     * VIEWS
     */

    // list of the view used by the program that are never supposed to be changed
    // also the list of the view code_id
    // MC_* is the Mask Code id that is expected never to change
    // MI_* is the Mask ID that is expected never to change
    const MC_START = "start";
    const MI_START = 2;
    const MC_WORD = "word";
    const MC_WORD_ADD = "word_add";
    const MC_WORD_EDIT = "word_edit";
    const MC_WORD_DEL = "word_del";
    const MC_WORD_FIND = "word_find";
    const MC_TRIPLE_ADD = "triple_add";
    const MC_TRIPLE_EDIT = "triple_edit";
    const MC_TRIPLE_DEL = "triple_del";
    const MC_VALUE_DISPLAY = "value";
    const MC_VALUE_ADD = "value_add";
    const MC_VALUE_EDIT = "value_edit";
    const MC_VALUE_DEL = "value_del";
    const MC_FORMULA_ADD = "formula_add";
    const MC_FORMULA_EDIT = "formula_edit";
    const MC_FORMULA_DEL = "formula_del";
    const MC_FORMULA_EXPLAIN = "formula_explain";
    const MC_FORMULA_TEST = "formula_test";
    const MC_SOURCE_ADD = "source_add";
    const MC_SOURCE_EDIT = "source_edit";
    const MC_SOURCE_DEL = "source_del";
    const MC_VERBS = "verbs";
    const MC_VERB_ADD = "verb_add";
    const MC_VERB_EDIT = "verb_edit";
    const MC_VERB_DEL = "verb_del";
    const MC_USER = "user";
    const MC_ERR_LOG = "error_log";
    const MC_ERR_UPD = "error_update";
    const MC_IMPORT = "import";
    // views to edit views
    const MC_VIEW_ADD = "view_add";
    const MC_VIEW_EDIT = "view_edit";
    const MC_VIEW_DEL = "view_del";
    const MC_COMPONENT_ADD = "component_add";
    const MC_COMPONENT_EDIT = "component_edit";
    const MC_COMPONENT_DEL = "component_del";
    const MC_COMPONENT_LINK = "component_link";
    const MC_COMPONENT_UNLINK = "component_unlink";

    // list of add system views which don't need an object
    const DSP_SYS_ADD = array(
        self::MC_WORD_ADD,
        self::MC_TRIPLE_ADD,
        self::MC_VALUE_ADD,
        self::MC_COMPONENT_ADD
    );


    /*
     * functions
     */

    /**
     * response to a get request
     *
     * @param string $api_obj the object as a json string that should be returned
     * @param string $msg the message as a json string that should be returned
     * @return void
     */
    private function get_response(string $api_obj, string $msg): void
    {
        // required headers
        header("Access-Control-Allow-Origin: *");
        header("Content-Type: application/json; charset=UTF-8");
        header("Access-Control-Allow-Methods: GET");

        // return the api json or the error message
        if ($msg == '') {

            // set response code - 200 OK
            http_response_code(200);

            // return e.g. the word object
            echo $api_obj;

        } else {

            // set response code - 400 Bad Request
            http_response_code(400);

            // tell the user no products found
            echo json_encode(
                array(self::URL_VAR_MSG => $msg)
            );
        }
    }

    /**
     * response to post, get, put and delete requests
     *
     * @param string $api_obj the object as a json string that should be returned
     * @param string $msg the message as a json string that should be returned
     * @param int $id the id of object that should be deleted
     * @return void
     */
    private function curl_response(string $api_obj, string $msg, int $id = 0, sandbox|combine_object|null $obj = null): void
    {
        // required headers
        header("Access-Control-Allow-Origin: *");
        header("Content-Type: application/json; charset=UTF-8");
        header("Access-Control-Allow-Methods: POST,GET,PUT,DELETE");

        // method switch
        $method = $_SERVER['REQUEST_METHOD'];
        log_debug($method);
        switch ($method) {
            case 'PUT':
                // get json object body to put
                $request_text = file_get_contents('php://input');
                $request_json = json_decode($request_text, true);
                $request_body = $this->check_api_msg($request_json);

                // call to backend
                $result = $this->put($request_body, $obj::class);

                // return the result
                if (is_numeric($result)) {

                    // set response code - 200 OK
                    http_response_code(200);
                    echo json_encode(
                        array(self::URL_VAR_ID => $result)
                    );
                } else {

                    // set response code - 400 Bad Request
                    http_response_code(400);
                    echo json_encode(
                        array(self::URL_VAR_MSG => $result)
                    );
                }
                break;
            case 'GET':
                // return the api json or the error message
                if ($msg == '') {

                    // set response code - 200 OK
                    http_response_code(200);

                    // return e.g. the word object
                    echo $api_obj;

                } else {

                    // set response code - 400 Bad Request
                    http_response_code(400);

                    // tell the user no object found
                    echo json_encode(
                        array(self::URL_VAR_MSG => $msg)
                    );
                }
                break;
            case 'POST':
                // return the api json or the error message
                if ($msg == '') {
                    $request_text = file_get_contents('php://input');
                    $request_json = json_decode($request_text, true);
                    $request_body = $this->check_api_msg($request_json);

                    // call to backend
                    $result = $this->post($request_body);

                    // return the result
                    if (is_numeric($result)) {
                        // set response code - 200 OK
                        http_response_code(200);
                        echo json_encode(
                            array(self::URL_VAR_ID => $result)
                        );
                    } else {

                        // set response code - 400 Bad Request
                        http_response_code(400);
                        echo json_encode(
                            array(self::URL_VAR_MSG => $result)
                        );
                    }
                }
                break;
            case 'DELETE':
                // return the api json or the error message
                if ($msg == '') {

                    if ($id > 0) {
                        $result = $obj->del($id);
                        if ($result->is_ok()) {
                            // set response code - 200 OK
                            http_response_code(200);
                        } else {
                            // set response code - 409 Conflict
                            http_response_code(409);

                            echo json_encode(
                                array(self::URL_VAR_RESULT => $result->get_last_message())
                            );
                        }
                    }
                } else {

                    // set response code - 400 Bad Request
                    http_response_code(400);
                    // set response code - 410 Gone
                    // http_response_code(410);
                    // set response code - 403 Forbidden
                    // http_response_code(403);

                    // tell the user no products found
                    echo json_encode(
                        array(self::URL_VAR_MSG => $msg)
                    );
                }
                break;
            default:
                // set response code - 400 Bad Request
                http_response_code(400);
                break;
        }
    }

    public
    function not_permitted(string $msg): void
    {
        http_response_code(401);
        $this->curl_response('', $msg);
    }

    /**
     * encode an user sandbox object for the frontend api
     * and response to a get request
     *
     * @param sandbox_api|combine_object_api $api_obj the object that should be encoded
     * @param string $msg if filled the message that should be shown to the user instead of the object
     * @return void
     */
    function get(sandbox_api|combine_object_api $api_obj, string $msg): void
    {
        // return the api json or the error message
        if ($msg == '') {
            $this->get_response(json_encode($api_obj), $msg);
        } else {
            // tell the user e.g. that no products found
            $this->get_response('', $msg);
        }
    }

    function get_list(list_api $api_obj, string $msg): void
    {
        // return the api json or the error message
        if ($msg == '') {
            $this->get_response(json_encode($api_obj), $msg);
        } else {
            // tell the user e.g. that no products found
            $this->get_response('', $msg);
        }
    }

    function get_api_msg(api_message $api_obj, string $msg): void
    {
        // return the api json or the error message
        if ($msg == '') {
            $this->get_response(json_encode($api_obj), $msg);
        } else {
            // tell the user e.g. that no products found
            $this->get_response('', $msg);
        }
    }

    function get_types(type_lists_api $api_obj, string $msg): void
    {
        // return the api json or the error message
        if ($msg == '') {
            $this->get_response(json_encode($api_obj), $msg);
        } else {
            // tell the user e.g. that no products found
            $this->get_response('', $msg);
        }
    }

    function get_export(object $api_obj, string $msg): void
    {
        // return the api json or the error message
        if ($msg == '') {
            $this->get_response(json_encode($api_obj), $msg);
        } else {
            // tell the user e.g. that no products found
            $this->get_response('', $msg);
        }
    }

    /**
     * check if an api message is fine
     * @param array|null $api_msg the complete api message including the header and in some cases several body parts
     * @param string $body_key to select a body part of the api message
     * @return array the message body if everything has been fine or an empty array
     */
    function check_api_msg(?array $api_msg, string $body_key = controller::API_BODY): array
    {
        $msg_ok = true;
        $body = array();
        if ($api_msg !== null) {
            // TODO check transfer time
            // TODO check if version matches
            if ($msg_ok) {
                if (array_key_exists($body_key, $api_msg)) {
                    $body = $api_msg[$body_key];
                } else {
                    // TODO activate Prio 3 next line and avoid these cases
                    // $msg_ok = false;
                    $body = $api_msg;
                    log_warning('message header missing in api message');
                }
            }
            if ($msg_ok) {
                return $body;
            } else {
                return array();
            }
        } else {
            return array();
        }
    }

    /**
     * encode a user sandbox object for the frontend api
     * and response to curl requests
     *
     * @param api_message $api_msg the object that should be encoded
     * @param string $msg if filled the message that should be shown to the user instead of the object
     * @param int $id
     * @param sandbox|combine_object $obj
     * @return void
     */
    function curl(api_message $api_msg, string $msg, int $id, sandbox|combine_object $obj): void
    {
        // return the api json or the error message
        if ($msg == '') {
            $this->curl_response(json_encode($api_msg), $msg, $id, $obj);
        } else {
            // tell the user e.g. that no products found
            $this->curl_response('', $msg, $id, $obj);
        }
    }

    function put(array $request, string $class): string
    {
        global $usr;
        $result = '';
        switch ($class) {
            case word::class:
                $wrd = new word($usr);
                $result = $wrd->save_from_api_msg($request)->get_last_message();
                if ($result == '') {
                    $result = $wrd->id();
                }
                break;
            case source::class:
                $src = new source($usr);
                $result = $src->save_from_api_msg($request)->get_last_message();
                if ($result == '') {
                    $result = $src->id();
                }
                break;
        }
        return $result;
    }

    function post(array $request): string
    {
        return 'post';
    }

    function delete(array $request): string
    {
        return 'delete';
    }

}
