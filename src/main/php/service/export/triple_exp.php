<?php

/*

  triple_exp.php - the simple export object for a triple
  -----------------
  
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

namespace cfg\export;

include_once SERVICE_EXPORT_PATH . 'sandbox_exp_link.php';

use JsonSerializable;

class triple_exp extends sandbox_exp_link implements JsonSerializable
{

    // field names used for JSON creation
    public ?string $description = null;
    public ?string $from = null;
    public ?string $verb = null;
    public ?string $to = null;
    public ?string $type = null;
    public ?string $view = null;
    public ?array $refs = null;

    function reset(): void
    {
        parent::reset();

        $this->description = '';
        $this->type = '';
        $this->from = null;
        $this->verb = null;
        $this->to = null;

        $this->view = '';
        $this->refs = null;
    }


    /*
     * interface
     */

    /**
     * @return array of the word vars excluding empty and default field values
     */
    function jsonSerialize(): array
    {
        $vars = get_object_vars($this);
        return array_filter($vars, fn($value) => !is_null($value));
    }

}
