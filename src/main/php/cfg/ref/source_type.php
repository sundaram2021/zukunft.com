<?php

/*

    model/ref/source_type.php - the base object for external source type such as pubmed
    -------------------------

    the source type is used for all external sources that have some coded functionality
    but does not allow a full bidirectional synchronisation like a reference type


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

namespace cfg\ref;

include_once MODEL_HELPER_PATH . 'type_object.php';

use cfg\helper\type_object;

class source_type extends type_object
{
    // list of the source types that have a coded functionality
    const XBRL = "xbrl";
    const XBRL_ID = 2; // the fixed database ID for testing
    const CSV = "csv";
    const CSV_ID = 3; // the fixed database ID for testing
    const PDF = "pdf";
    const PDF_ID = 4; // the fixed database ID for testing

    // the url that can be used to receive data if the external key is added
    // public ?string $url = null;

    /*
     * database link
     */

    // comments used for the database creation
    const TBL_COMMENT = 'to link predefined behaviour to a source';

}
