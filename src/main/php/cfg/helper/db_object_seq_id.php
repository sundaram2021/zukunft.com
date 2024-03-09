<?php

/*

    model/helper/db_object_seq_id.php - a base object for all database objects which have a unique id based on an int sequence
    ---------------------------------

    similar to db_object_seq_id


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

namespace cfg;

include_once MODEL_HELPER_PATH . 'db_object.php';

use api\system\db_object as db_object_api;
use cfg\db\sql;
use cfg\db\sql_field_default;
use cfg\db\sql_field_type;
use cfg\db\sql_par;

class db_object_seq_id extends db_object
{

    /*
     * object vars
     */

    // database fields that are used in all model objects
    // the database id is the unique prime key
    protected int $id;


    /*
     * construct and map
     */

    /**
     * reset the id to null to indicate that the database object has not been loaded
     */
    function __construct()
    {
        $this->set_id(0);
    }

    /**
     * map the database fields to the object fields
     * to be extended by the child functions
     *
     * @param array|null $db_row with the data directly from the database
     * @param string $id_fld the name of the id field as set in the child class
     * @return bool true if the user sandbox object is loaded and valid
     */
    function row_mapper(?array $db_row, string $id_fld = ''): bool
    {
        $result = false;
        $this->set_id(0);
        if ($db_row != null) {
            if (array_key_exists($id_fld, $db_row)) {
                if ($db_row[$id_fld] != 0) {
                    $this->set_id($db_row[$id_fld]);
                    $result = true;
                }
            }
        }
        return $result;
    }


    /*
     * set and get
     */

    /**
     * set the unique database id of a database object
     * @param int $id used in the row mapper and to set a dummy database id for unit tests
     */
    function set_id(int $id): void
    {
        $this->id = $id;
    }

    /**
     * @return int the database id which is not 0 if the object has been saved
     * the internal null value is used to detect if database saving has been tried
     */
    function id(): int
    {
        return $this->id;
    }


    /*
     * cast
     */

    /**
     * @return db_object_api the source frontend api object
     */
    function api_db_obj(): db_object_api
    {
        return new db_object_api($this->id());
    }

    /**
     * @returns string the api json message for the object as a string
     */
    function api_json(): string
    {
        return $this->api_db_obj()->get_json();
    }


    /*
     * sql create
     */

    /**
     * the sql statement to create the table
     * is e.g. overwriten for the user sandbox objects
     *
     * @param sql $sc with the target db_type set
     * @return string the sql statement to create the table
     */
    function sql_table(sql $sc): string
    {
        $sql = $sc->sql_separator();
        $sql .= $this->sql_table_create($sc, false, [], '', false);
        return $sql;
    }

    /**
     * the sql statement to create the database indices
     * is e.g. overwriten for the user sandbox objects
     *
     * @param sql $sc with the target db_type set
     * @return string the sql statement to create the indices
     */
    function sql_index(sql $sc): string
    {
        $sql = $sc->sql_separator();
        $sql .= $this->sql_index_create($sc, false, [],false);
        return $sql;
    }

    /**
     * the sql statements to create all foreign keys
     * is e.g. overwriten for the user sandbox objects
     *
     * @param sql $sc with the target db_type set
     * @return string the sql statement to create the foreign keys
     */
    function sql_foreign_key(sql $sc): string
    {
        return $this->sql_foreign_key_create($sc, false, [],false);
    }

    /**
     * @param bool $usr_table create a second table for the user overwrites
     * @param bool $is_sandbox true if the standard sandbox fields should be included
     * @return array[] with the parameters of the table fields
     */
    protected function sql_all_field_par(bool $usr_table = false, bool $is_sandbox = true): array
    {
        $fields = [];
        if (!$usr_table) {
            if ($is_sandbox) {
                $fields = array_merge($this->sql_id_field_par($usr_table), sandbox::FLD_ALL_OWNER);
                $fields = array_merge($fields, $this::FLD_LST_MUST_BE_IN_STD);
            } else {
                $fields = array_merge($this->sql_id_field_par(false), $this::FLD_LST_ALL);
                $fields = array_merge($fields, $this::FLD_LST_EXTRA);
            }
        } else {
            $fields = array_merge($this->sql_id_field_par($usr_table), sandbox::FLD_ALL_CHANGER);
            $fields = array_merge($fields, $this::FLD_LST_MUST_BUT_USER_CAN_CHANGE);
        }
        $fields = array_merge($fields, $this::FLD_LST_USER_CAN_CHANGE);
        if (!$usr_table) {
            $fields = array_merge($fields, $this::FLD_LST_NON_CHANGEABLE);
        }
        if ($is_sandbox) {
            $fields = array_merge($fields, sandbox::FLD_LST_ALL);
        }
        return $fields;
    }

    /**
     * @return array[] with the parameters of the table key field
     */
    private function sql_id_field_par(bool $usr_table = false): array
    {
        if (!$usr_table) {
            return array([
                $this->id_field(),
                sql_field_type::KEY_INT,
                sql_field_default::NOT_NULL,
                '', '',
                'the internal unique primary index']);
        } else {
            return array([
                $this->id_field(),
                sql_field_type::KEY_PART_INT,
                sql_field_default::NOT_NULL,
                sql::INDEX, $this::class,
                'with the user_id the internal unique primary index']);
        }
    }


    /*
     * load
     */

    /**
     * create an SQL statement to retrieve a user sandbox object by id from the database
     *
     * @param sql $sc with the target db_type set
     * @param int $id the id of the user sandbox object
     * @return sql_par the SQL statement, the name of the SQL statement and the parameter list
     */
    function load_sql_by_id(sql $sc, int $id): sql_par
    {
        return parent::load_sql_by_id_str($sc, $id, $this::class);
    }

    /**
     * load one database row e.g. word, triple, value, formula, result, view, component or log entry from the database
     * @param sql_par $qp the query parameters created by the calling function
     * @return int the id of the object found and zero if nothing is found
     */
    protected function load(sql_par $qp): int
    {
        parent::load_without_id_return($qp);
        return $this->id();
    }


    /*
     * im- and export
     */

    /**
     * general part to import a database object from a JSON array object
     *
     * @param object|null $test_obj if not null the unit test object to get a dummy seq id
     * @return user_message the status of the import and if needed the error messages that should be shown to the user
     */
    function import_db_obj(db_object_seq_id $db_obj, object $test_obj = null): user_message
    {
        $result = new user_message();
        // add a dummy id for unit testing
        if ($test_obj) {
            $db_obj->set_id($test_obj->seq_id());
        }
        return $result;
    }


    /*
     * information
     */

    /**
     * @return bool true if the object has a valid database id
     */
    function isset(): bool
    {
        if ($this->id == null) {
            return false;
        } else {
            if ($this->id != 0) {
                return true;
            } else {
                return false;
            }
        }
    }


    /*
     * dummy functions that should always be overwritten by the child
     */

    /**
     * get the name of the database object (only used by named objects)
     *
     * @return string the name from the object e.g. word using the same function as the phrase and term
     */
    function name(): string
    {
        return 'ERROR: name function not overwritten by child';
    }

    /**
     * load a row from the database selected by id
     * @param int $id the id of the word, triple, formula, verb, view or view component
     * @return int the id of the object found and zero if nothing is found
     */
    function load_by_id(int $id): int
    {
        global $db_con;

        log_debug($id);
        $qp = $this->load_sql_by_id($db_con->sql_creator(), $id);
        return $this->load($qp);
    }

    /**
     * load a row from the database selected by name (only used by named objects)
     * @param string $name the name of the word, triple, formula, verb, view or view component
     * @return int the id of the object found and zero if nothing is found
     */
    function load_by_name(string $name): int
    {
        return 0;
    }


    /*
     * debug
     */

    /**
     * @return string with the unique database id mainly for child dsp_id() functions
     */
    function dsp_id(): string
    {
        if ($this->id() != 0) {
            return ' (' . $this->id_field() . ' ' . $this->id() . ')';
        } else {
            return ' (' . $this->id_field() . ' no set)';
        }
    }

}
