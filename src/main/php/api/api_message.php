<?php

/*

    api/message_header.php - the JSON header object for the frontend API
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

namespace controller;

include_once SERVICE_PATH . 'config.php';
include_once SHARED_PATH . 'library.php';

use cfg\config;
use cfg\db\sql_db;
use cfg\user\user;
use DateTime;
use DateTimeInterface;
use html\html_base;
use shared\library;

class api_message
{

    /*
     * message types
     */

    // the message types for fast format detection
    const SYS_LOG = 'sys_log';


    /*
     * object vars
     */

    // field names used for JSON creation
    public string $pod;       // the pod that has created the message
    public string $type;      // defines the message formal (just used for testing and easy debugging)
    public int $user_id;      // to double-check to the session user
    public string $user;      // for fast debugging
    public string $version;   // to prevent communication error due to incompatible program versions
    public string $timestamp; // for automatic delay problem detection
    public string $config;    // timestamp of the configuration to include the config in the response if needed
    public object $body;      // the json payload of the message


    /*
     * construct and map
     */

    /**
     * create and set the api message header information
     * @param sql_db $db_con the active database link to get the configuration from the database
     * @param string $class the class of the message
     * @param user $usr the user view that the api message should contain
     */
    function __construct(sql_db $db_con, string $class, user $usr)
    {
        $lib = new library();
        $cfg = new config();
        if ($db_con->connected()) {
            $this->pod = $cfg->get_db(config::SITE_NAME, $db_con);
        } else {
            // for unit tests use the default pod name
            $this->pod = POD_NAME;
        }
        $class_name = $lib->class_to_name($class);
        $this->type = $class_name;
        $this->set_user($usr);
        $this->version = PRG_VERSION;
        $this->timestamp = (new DateTime())->format(DateTimeInterface::ATOM);
    }


    /*
     * set and get
     */

    function set_user(?user $usr): void
    {
        if ($usr != null) {
            if ($usr->id() > 0) {
                $this->user_id = $usr->id();
                $this->user = $usr->name;
            }
        }
    }

    function add_body(object $api_obj): void
    {
        $this->body = $api_obj;
    }

    /**
     * @return string the frontend API JSON string
     */
    function get_json(): string
    {
        return json_encode($this);
    }

    /**
     * @return array the frontend API JSON as an array
     */
    function get_json_array(): array
    {
        return json_decode(json_encode($this), true);
    }


    /*
     * to review
     */

    function get_html_header(string $title): string
    {
        if ($title == null) {
            $title = 'api message';
        } elseif ($title == '') {
            $title = 'api message';
        }
        $html = new html_base();
        return $html->header($title);
    }

    function get_html_footer(): string
    {
        $html = new html_base();
        return $html->footer();
    }

}
