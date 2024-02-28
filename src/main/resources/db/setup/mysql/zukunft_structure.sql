-- phpMyAdmin SQL Dump
-- version 4.2.12deb2+deb8u8
-- http://www.phpmyadmin.net

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT = @@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS = @@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION = @@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database:`zukunft`
--

-- --------------------------------------------------------

--
-- table structure for the core configuration of this pod e.g. the program version or pod url
--

CREATE TABLE IF NOT EXISTS config
(
    config_id   bigint           NOT NULL COMMENT 'the internal unique primary index',
    config_name varchar(255) DEFAULT NULL COMMENT 'short name of the configuration entry to be shown to the admin',
    code_id     varchar(255)     NOT NULL COMMENT 'unique id text to select a configuration value from the code',
    `value`     varchar(255) DEFAULT NULL COMMENT 'the configuration value as a string',
    description text         DEFAULT NULL COMMENT 'text to explain the config value to an admin user'
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8
    COMMENT 'for the core configuration of this pod e.g. the program version or pod url';

-- --------------------------------------------------------

--
-- Table structure for system log types e.g. info, warning and error
--

CREATE TABLE IF NOT EXISTS `sys_log_types`
(
    `sys_log_type_id` int(11)      NOT NULL,
    `type_name`       varchar(200) NOT NULL,
    `code_id`         varchar(50)  NOT NULL
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8;

-- --------------------------------------------------------

--
-- table structure to define the status of internal errors
--

CREATE TABLE IF NOT EXISTS sys_log_status
(
    sys_log_status_id bigint           NOT NULL COMMENT 'the internal unique primary index',
    type_name         varchar(255)     NOT NULL COMMENT 'the unique type name as shown to the user and used for the selection',
    code_id           varchar(255) DEFAULT NULL COMMENT 'this id text is unique for all code links,is used for system im- and export and is used to link coded functionality to a specific word e.g. to get the values of the system configuration',
    description       text         DEFAULT NULL COMMENT 'text to explain the type to the user as a tooltip; to be replaced by a language form entry',
    action            varchar(255) DEFAULT NULL COMMENT 'description of the action to get to this status'
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8
    COMMENT 'to define the status of internal errors';


-- --------------------------------------------------------

--
-- table structure to group the system log entries by function
--

CREATE TABLE IF NOT EXISTS sys_log_functions
(
    sys_log_function_id   bigint           NOT NULL COMMENT 'the internal unique primary index',
    sys_log_function_name varchar(255)     NOT NULL COMMENT 'the unique type name as shown to the user and used for the selection',
    code_id               varchar(255) DEFAULT NULL COMMENT 'this id text is unique for all code links,is used for system im- and export and is used to link coded functionality to a specific word e.g. to get the values of the system configuration',
    description           text         DEFAULT NULL COMMENT 'text to explain the type to the user as a tooltip; to be replaced by a language form entry'
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8
    COMMENT 'to group the system log entries by function';

-- --------------------------------------------------------

--
-- table structure for system error traking and to measure execution times
--

CREATE TABLE IF NOT EXISTS sys_log
(
    sys_log_id          bigint     NOT NULL COMMENT 'the internal unique primary index',
    sys_log_time        timestamp  NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'timestamp of the creation',
    sys_log_type_id     bigint     NOT NULL COMMENT 'the level e.g. debug,info,warning,error or fatal',
    sys_log_function_id bigint     NOT NULL COMMENT 'the function or function group for the entry e.g. db_write to measure the db write times',
    sys_log_text        text   DEFAULT NULL COMMENT 'the short text of the log entry to indentify the error and to reduce the number of double entries',
    sys_log_description text   DEFAULT NULL COMMENT 'the lond description with all details of the log entry to solve ti issue',
    sys_log_trace       text   DEFAULT NULL COMMENT 'the generated code trace to local the path to the error cause',
    user_id             bigint DEFAULT NULL COMMENT 'the id of the user who has caused the log entry',
    solver_id           bigint DEFAULT NULL COMMENT 'user id of the user that is trying to solve the problem',
    sys_log_status_id   bigint     NOT NULL DEFAULT 1
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8
    COMMENT 'for system error traking and to measure execution times';

-- --------------------------------------------------------

--
-- Table structure for table`sys_scripts`
--

CREATE TABLE IF NOT EXISTS `sys_scripts`
(
    `sys_script_id`   int(11)      NOT NULL,
    `sys_script_name` varchar(200) NOT NULL
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8;

--
-- Table structure for table`sys_script_times`
--

CREATE TABLE IF NOT EXISTS `sys_script_times`
(
    `sys_script_time`  timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `sys_script_start` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
    `sys_script_id`    int(11) NOT NULL,
    `url` varchar(250) DEFAULT NULL
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

-- --------------------------------------------------------

--
-- Table structure for table`calc_and_cleanup_task_types`
--

CREATE TABLE IF NOT EXISTS `calc_and_cleanup_task_types`
(
    `calc_and_cleanup_task_type_id` int(11)      NOT NULL,
    `type_name`                     varchar(200) NOT NULL,
    `description`                   text,
    `code_id`                       varchar(50)  NOT NULL
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8;

--
-- Table structure for table`calc_and_cleanup_tasks`
--

CREATE TABLE IF NOT EXISTS `calc_and_cleanup_tasks`
(
    `calc_and_cleanup_task_id`      int(11)   NOT NULL,
    `user_id`                       int(11)   NOT NULL,
    `request_time`                  timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `start_time`                    timestamp          DEFAULT NULL,
    `end_time`                      timestamp          DEFAULT NULL,
    `calc_and_cleanup_task_type_id` int(11)   NOT NULL,
    `row_id`                        int(11)   DEFAULT NULL,
    `change_field_id`               int(11)            DEFAULT NULL
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8;

-- --------------------------------------------------------

--
-- table structure for the user types e.g. to set the confirmation level of a user
--

CREATE TABLE IF NOT EXISTS user_types
(
    user_type_id bigint NOT NULL COMMENT 'the internal unique primary index',
    type_name varchar(255) NOT NULL COMMENT 'the unique type name as shown to the user and used for the selection',
    code_id varchar(255) DEFAULT NULL COMMENT 'this id text is unique for all code links,is used for system im- and export and is used to link coded functionality to a specific word e.g. to get the values of the system configuration',
    description text DEFAULT NULL COMMENT 'text to explain the type to the user as a tooltip; to be replaced by a language form entry'
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8
    COMMENT 'for the user types e.g. to set the confirmation level of a user';

-- --------------------------------------------------------

--
-- table structure to define the user roles and read and write rights
--

CREATE TABLE IF NOT EXISTS user_profiles
(
    user_profile_id bigint        NOT NULL COMMENT 'the internal unique primary index',
    type_name    varchar(255)     NOT NULL COMMENT 'the unique type name as shown to the user and used for the selection',
    code_id      varchar(255) DEFAULT NULL COMMENT 'this id text is unique for all code links,is used for system im- and export and is used to link coded functionality to a specific word e.g. to get the values of the system configuration',
    description  text         DEFAULT NULL COMMENT 'text to explain the type to the user as a tooltip; to be replaced by a language form entry',
    right_level  smallint     DEFAULT NULL COMMENT 'the access right level to prevent unpermitted right gaining'
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8
    COMMENT 'to define the user roles and read and write rights';

--
-- Table structure for table`users`
--

CREATE TABLE IF NOT EXISTS `users`
(
    `user_id`                  int(11)      NOT NULL,
    `user_name`                varchar(100) NOT NULL,
    `description`              text         DEFAULT NULL,
    `code_id`                  varchar(50)           DEFAULT NULL COMMENT 'to select e.g. the system batch user',
    `right_level`              int(11)               DEFAULT NULL,
    `password`                 varchar(200)          DEFAULT NULL,
    `email`                    varchar(200)          DEFAULT NULL,
    `email_verified`           tinyint(4)            DEFAULT NULL,
    `email_alternative`        varchar(200)          DEFAULT NULL,
    `ip_address`               varchar(50)           DEFAULT NULL,
    `mobile_number`            varchar(50)           DEFAULT NULL,
    `mobile_verified`          tinyint(4)            DEFAULT NULL,
    `first_name`               varchar(200)          DEFAULT NULL,
    `last_name`                varchar(200)          DEFAULT NULL,
    `street`                   varchar(300)          DEFAULT NULL,
    `place`                    varchar(200)          DEFAULT NULL,
    `country_id`               int(11)               DEFAULT NULL,
    `post_verified`            tinyint(4)            DEFAULT NULL,
    `official_id`              varchar(200)          DEFAULT NULL COMMENT 'such as the passport id',
    `user_official_id_type_id` int(11)               DEFAULT NULL,
    `official_verified`        int(11)               DEFAULT NULL,
    `user_type_id`             int(11)               DEFAULT NULL,
    `last_word_id`             int(11)               DEFAULT NULL COMMENT 'the last term that the user had used',
    `last_mask_id`             int(11)               DEFAULT NULL COMMENT 'the last mask that the user has used',
    `is_active`                tinyint(4)   NOT NULL DEFAULT '0',
    `dt`                       timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `last_logoff`              timestamp    NULL     DEFAULT NULL,
    `user_profile_id`          int(11)               DEFAULT NULL,
    `source_id`                int(11)               DEFAULT NULL COMMENT 'the last source used by this user to have a default for the next value',
    `activation_key`           varchar(200)          DEFAULT NULL,
    `activation_key_timeout`   timestamp    NULL     DEFAULT NULL
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8 COMMENT ='only users can add data';

--
-- Table structure for table`user_official_types`
--

CREATE TABLE IF NOT EXISTS `user_official_types`
(
    `user_official_type_id` int(11)      NOT NULL,
    `type_name`             varchar(200) NOT NULL,
    `code_id`               varchar(100) DEFAULT NULL,
    `comment`               text         DEFAULT NULL
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8;

--
-- Table structure for table`user_requests`
--

CREATE TABLE IF NOT EXISTS `user_requests`
(
    `id`          int(11)     NOT NULL,
    `uid`         int(11)     NOT NULL,
    `request_key` varchar(20) NOT NULL,
    `expire`      datetime    NOT NULL,
    `type`        varchar(20) NOT NULL
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

--
-- Table structure for table`user_attempts`
--

CREATE TABLE IF NOT EXISTS `user_attempts`
(
    `id`          int(11)     NOT NULL,
    `ip`          varchar(39) NOT NULL,
    `expire_date` datetime    NOT NULL
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

--
-- Table structure for table`user_blocked_ips`
--

CREATE TABLE IF NOT EXISTS `user_blocked_ips`
(
    `user_blocked_id` int(11)     NOT NULL,
    `ip_from`         varchar(45) NOT NULL,
    `ip_to`           varchar(45) NOT NULL,
    `reason`          text        NOT NULL,
    `is_active`       tinyint(4) DEFAULT '1'
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8;

-- --------------------------------------------------------

--
-- Table structure for table`sessions`
--

CREATE TABLE IF NOT EXISTS `sessions`
(
    `id`          int(11)      NOT NULL,
    `uid`         int(11)      NOT NULL,
    `hash`        varchar(40)  NOT NULL,
    `expire_date` datetime     NOT NULL,
    `ip`          varchar(39)  NOT NULL,
    `agent`       varchar(200) NOT NULL,
    `cookie_crc`  varchar(40)  NOT NULL
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

-- --------------------------------------------------------

--
-- Table structure for table`change_actions`
--

CREATE TABLE IF NOT EXISTS `change_actions`
(
    `change_action_id`   int(11)      NOT NULL,
    `change_action_name` varchar(200) NOT NULL,
    `description`        text,
    `code_id`            varchar(50)  NOT NULL
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8;

--
-- Table structure for table`change_tables`
--

CREATE TABLE IF NOT EXISTS `change_tables`
(
    `change_table_id`   int(11)      NOT NULL,
    `change_table_name` varchar(100) NOT NULL COMMENT 'the real name',
    `description`       varchar(1000) DEFAULT NULL COMMENT 'the user readable name',
    `code_id`           varchar(50)   DEFAULT NULL COMMENT 'with this field tables can be combined in case of renaming'
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8 COMMENT ='to avoid log changes in case a table is renamed';

--
-- Table structure for table`change_fields`
--

CREATE TABLE IF NOT EXISTS `change_fields`
(
    `change_field_id`   int(11)      NOT NULL,
    `change_field_name` varchar(255) NOT NULL,
    `table_id`          int(11)      NOT NULL COMMENT 'because every field must only be unique within a table',
    `description`       text,
    `code_id`           varchar(100) DEFAULT NULL COMMENT 'to display the change with some linked information'
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8;

-- --------------------------------------------------------

--
-- Table structure for table`changes`
--

CREATE TABLE IF NOT EXISTS `changes`
(
    `change_id`        int(11)   NOT NULL,
    `change_time`      timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP COMMENT 'time when the value has been changed',
    `user_id`          int(11)   NOT NULL,
    `change_action_id` int(11)   NOT NULL,
    `change_field_id`  int(11)   NOT NULL,
    `row_id`           int(11)            DEFAULT NULL,
    `old_value`        varchar(300)       DEFAULT NULL,
    `new_value`        varchar(300)       DEFAULT NULL,
    `old_id`           int(11)            DEFAULT NULL COMMENT 'old value id',
    `new_id`           int(11)            DEFAULT NULL COMMENT 'new value id'
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8 COMMENT ='to log all changes';

--
-- Table structure to log the value changes done by the users
--

CREATE TABLE IF NOT EXISTS `changes_values`
(
    `change_id`        int(11)   NOT NULL,
    `change_time`      timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP COMMENT 'time when the value has been changed',
    `user_id`          int(11)   NOT NULL,
    `change_action_id` int(11)   NOT NULL,
    `change_field_id`  int(11)   NOT NULL,
    `group_id`         char(112) NOT NULL,
    `old_value`        varchar(300)       DEFAULT NULL,
    `new_value`        varchar(300)       DEFAULT NULL
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8 COMMENT ='to log all number changes';

--
-- Table structure to log changes of numbers related to not more than four prime phrases
--

CREATE TABLE IF NOT EXISTS `changes_values_prime`
(
    `change_id`        int(11)   NOT NULL,
    `change_time`      timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP COMMENT 'time when the value has been changed',
    `user_id`          int(11)   NOT NULL,
    `change_action_id` int(11)   NOT NULL,
    `change_field_id`  int(11)   NOT NULL,
    `group_id`         int(11)   NOT NULL,
    `old_value`        varchar(300)       DEFAULT NULL,
    `new_value`        varchar(300)       DEFAULT NULL
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8 COMMENT = 'to log changes of numbers related to not more than four prime phrases';

--
-- Table structure to log changes of numbers related to more than 16 phrases
--

CREATE TABLE IF NOT EXISTS `changes_values_big`
(
    `change_id`        int(11)   NOT NULL,
    `change_time`      timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP COMMENT 'time when the value has been changed',
    `user_id`          int(11)   NOT NULL,
    `change_action_id` int(11)   NOT NULL,
    `change_field_id`  int(11)   NOT NULL,
    `group_id`         varchar   NOT NULL,
    `old_value`        varchar(300)       DEFAULT NULL,
    `new_value`        varchar(300)       DEFAULT NULL
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8 COMMENT = 'to log changes of numbers related to more than 16 phrases';

--
-- Table structure for table`change_links`
--

CREATE TABLE IF NOT EXISTS `change_links`
(
    `change_link_id`   int(11)   NOT NULL,
    `change_time`      timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `user_id`          int(11)   NOT NULL,
    `change_action_id` int(11)   NOT NULL,
    `change_table_id`  int(11)   NOT NULL,
    `old_from_id`      int(11)            DEFAULT NULL,
    `old_link_id`      int(11)            DEFAULT NULL,
    `old_to_id`        int(11)            DEFAULT NULL,
    `old_text_from`    text,
    `old_text_link`    text,
    `old_text_to`      text,
    `new_from_id`      int(11)            DEFAULT NULL,
    `new_link_id`      int(11)            DEFAULT NULL,
    `new_to_id`        int(11)            DEFAULT NULL COMMENT 'either internal row id or the ref type id of the external system e.g. 2 for wikidata',
    `new_text_from`    text,
    `new_text_link`    text,
    `new_text_to`      text COMMENT 'the fixed text to display to the user or the external reference id e.g. Q1 (for universe) in case of wikidata',
    `row_id`           int(11)            DEFAULT NULL
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8;

-- --------------------------------------------------------

--
-- Table structure for table`comments`
--

CREATE TABLE IF NOT EXISTS `comments`
(
    `comment_id` int(11)  NOT NULL,
    `table_id`   int(100) NOT NULL,
    `row_id`     int(11)  NOT NULL,
    `comment`    text     NOT NULL
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='separate table because it is expected that only a few record';

-- --------------------------------------------------------

--
-- table structure for the write access control
--

CREATE TABLE IF NOT EXISTS protection_types
(
    protection_type_id bigint           NOT NULL COMMENT 'the internal unique primary index',
    type_name          varchar(255)     NOT NULL COMMENT 'the unique type name as shown to the user and used for the selection',
    code_id            varchar(255) DEFAULT NULL COMMENT 'this id text is unique for all code links,is used for system im- and export and is used to link coded functionality to a specific word e.g. to get the values of the system configuration',
    description        text         DEFAULT NULL COMMENT 'text to explain the type to the user as a tooltip; to be replaced by a language form entry'
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8
    COMMENT 'for the write access control';

-- --------------------------------------------------------

--
-- table structure for the read access control
--

CREATE TABLE IF NOT EXISTS share_types
(
    share_type_id bigint           NOT NULL COMMENT 'the internal unique primary index',
    type_name     varchar(255)     NOT NULL COMMENT 'the unique type name as shown to the user and used for the selection',
    code_id       varchar(255) DEFAULT NULL COMMENT 'this id text is unique for all code links,is used for system im- and export and is used to link coded functionality to a specific word e.g. to get the values of the system configuration',
    description   text         DEFAULT NULL COMMENT 'text to explain the type to the user as a tooltip; to be replaced by a language form entry'
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8
    COMMENT 'for the read access control';

-- --------------------------------------------------------

--
-- table structure for the phrase type to set the predefined behaviour of a word or triple
--

CREATE TABLE IF NOT EXISTS phrase_types
(
    phrase_type_id bigint       NOT NULL     COMMENT 'the internal unique primary index',
    type_name      varchar(255) NOT NULL     COMMENT 'the unique type name as shown to the user and used for the selection',
    code_id        varchar(255) DEFAULT NULL COMMENT 'this id text is unique for all code links,is used for system im- and export and is used to link coded functionality to a specific word e.g. to get the values of the system configuration',
    description    text         DEFAULT NULL COMMENT 'text to explain the type to the user as a tooltip; to be replaced by a language form entry',
    scaling_factor bigint       DEFAULT NULL COMMENT 'e.g. for percent the scaling factor is 100',
    word_symbol    varchar(255) DEFAULT NULL COMMENT 'e.g. for percent the symbol is %'
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8
    COMMENT 'for the phrase type to set the predefined behaviour of a word or triple';

-- --------------------------------------------------------

--
-- Table structure for table`languages`
--

CREATE TABLE IF NOT EXISTS `languages`
(
    `language_id`    int(11)      NOT NULL,
    `language_name`  varchar(200) NOT NULL,
    `code_id`        varchar(50)  NOT NULL,
    `wikimedia_code` varchar(50)  NOT NULL,
    `description`    text
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8;

--
-- Table structure for table`language_forms`
--

CREATE TABLE IF NOT EXISTS `language_forms`
(
    `language_form_id`   int(11) NOT NULL,
    `language_form_name` varchar(200) DEFAULT NULL COMMENT 'type of adjustment of a term in a language e.g. plural',
    `code_id`            varchar(50)  DEFAULT NULL,
    `language_id`        int(11) NOT NULL
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8;

-- --------------------------------------------------------

--
-- table structure for a short text, that can be used to search for values or results with a 64 bit database key because humans will never be able to use more than a few million words
--

CREATE TABLE IF NOT EXISTS words
(
    word_id        bigint       NOT     NULL COMMENT 'the internal unique primary index',
    user_id        bigint       DEFAULT NULL COMMENT 'the owner / creator of the word',
    word_name      varchar(255) NOT     NULL COMMENT 'the text used for searching',
    plural         varchar(255) DEFAULT NULL COMMENT 'to be replaced by a language form entry; TODO to be move to language forms',
    description    text         DEFAULT NULL COMMENT 'to be replaced by a language form entry',
    phrase_type_id bigint       DEFAULT NULL COMMENT 'to link coded functionality to words e.g. to exclude measure words from a percent result',
    view_id        bigint       DEFAULT NULL COMMENT 'the default mask for this word',
    `values`       bigint       DEFAULT NULL COMMENT 'number of values linked to the word, which gives an indication of the importance',
    inactive       smallint     DEFAULT NULL COMMENT 'true if the word is not yet active e.g. because it is moved to the prime words with a 16 bit id',
    code_id        varchar(255) DEFAULT NULL COMMENT 'to link coded functionality to a specific word e.g. to get the values of the system configuration',
    excluded       smallint     DEFAULT NULL COMMENT 'true if a user, but not all, have removed it',
    share_type_id  smallint     DEFAULT NULL COMMENT 'to restrict the access',
    protect_id     smallint     DEFAULT NULL COMMENT 'to protect against unwanted changes'
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8
    COMMENT 'for a short text, that can be used to search for values or results with a 64 bit database key because humans will never be able to use more than a few million words';

--
-- table structure to save user specific changes for a short text, that can be used to search for values or results with a 64 bit database key because humans will never be able to use more than a few million words
--

CREATE TABLE IF NOT EXISTS user_words
(
    word_id        bigint       NOT NULL              COMMENT 'with the user_id the internal unique primary index',
    user_id        bigint       NOT NULL              COMMENT 'the changer of the word',
    language_id    bigint       NOT NULL DEFAULT 1    COMMENT 'the text used for searching',
    word_name      varchar(255)          DEFAULT NULL COMMENT 'the text used for searching',
    plural         varchar(255)          DEFAULT NULL COMMENT 'to be replaced by a language form entry; TODO to be move to language forms',
    description    text                  DEFAULT NULL COMMENT 'to be replaced by a language form entry',
    phrase_type_id bigint                DEFAULT NULL COMMENT 'to link coded functionality to words e.g. to exclude measure words from a percent result',
    view_id        bigint                DEFAULT NULL COMMENT 'the default mask for this word',
    `values`       bigint                DEFAULT NULL COMMENT 'number of values linked to the word, which gives an indication of the importance',
    excluded       smallint              DEFAULT NULL COMMENT 'true if a user, but not all, have removed it',
    share_type_id  smallint              DEFAULT NULL COMMENT 'to restrict the access',
    protect_id     smallint              DEFAULT NULL COMMENT 'to protect against unwanted changes'
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8
    COMMENT 'for a short text, that can be used to search for values or results with a 64 bit database key because humans will never be able to use more than a few million words';
-- --------------------------------------------------------

--
-- Table structure for table`word_del_confirms`
--

CREATE TABLE IF NOT EXISTS `word_del_confirms`
(
    `word_del_request_id` int(11)   NOT NULL,
    `user_id`             int(11)   NOT NULL,
    `confirm`             timestamp NULL DEFAULT NULL,
    `reject`              timestamp NULL DEFAULT NULL
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

--
-- Table structure for table`word_del_requests`
--

CREATE TABLE IF NOT EXISTS `word_del_requests`
(
    `word_del_request_id` int(11)      NOT NULL,
    `word_id`             int(11)      NOT NULL,
    `word_name`           varchar(200) NOT NULL,
    `started`             timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `canceled`            timestamp    NULL     DEFAULT NULL,
    `confirmed`           timestamp    NULL     DEFAULT NULL,
    `finished`            timestamp    NULL     DEFAULT NULL,
    `user_id`             int(11)      NOT NULL COMMENT 'the user who has requested the term deletion'
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

-- --------------------------------------------------------

--
-- Table structure for table`word_periods`
--

CREATE TABLE IF NOT EXISTS `word_periods`
(
    `word_id` int(11)  NOT NULL,
    `from`    datetime NOT NULL,
    `to`      datetime NOT NULL
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='to define the time period for time terms';

-- --------------------------------------------------------

--
-- Table structure for table`verbs`
--

CREATE TABLE IF NOT EXISTS `verbs`
(
    `verb_id`             int(11)      NOT NULL,
    `verb_name`           varchar(100) NOT NULL,
    `code_id`             varchar(255) DEFAULT NULL,
    `description`         text,
    `condition_type`      int(11)      DEFAULT NULL,
    `formula_name`        varchar(200) DEFAULT NULL COMMENT 'naming used in formulas',
    `name_plural_reverse` varchar(200) DEFAULT NULL COMMENT 'english description for the reverse list, e.g. Companies are ...',
    `name_plural`         varchar(200) DEFAULT NULL,
    `name_reverse`        varchar(200) DEFAULT NULL,
    `words`               int(11)      DEFAULT NULL COMMENT 'used for how many terms'
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8 COMMENT ='it is fixed coded how to behavior for each type is';

-- --------------------------------------------------------

--
-- Table structure for table`verb_usages`
--

CREATE TABLE IF NOT EXISTS `verb_usages`
(
    `verb_usage_id` int(11) NOT NULL,
    `verb_id`       int(11) NOT NULL,
    `table_id`      int(11) NOT NULL
) ENGINE = InnoDB
  DEFAULT CHARSET = latin1;

-- --------------------------------------------------------

--
-- table structure to link one word or triple with a verb to another word or triple
--

CREATE TABLE IF NOT EXISTS triples
(
    triple_id           bigint           NOT NULL COMMENT 'the internal unique primary index',
    user_id             bigint       DEFAULT NULL COMMENT 'the owner / creator of the triple',
    from_phrase_id      bigint           NOT NULL COMMENT 'the phrase_id that is linked',
    verb_id             bigint           NOT NULL COMMENT 'the verb_id that defines how the phrases are linked',
    to_phrase_id        bigint           NOT NULL COMMENT 'the phrase_id to which the first phrase is linked',
    triple_name         varchar(255) DEFAULT NULL COMMENT 'the name used which must be unique within the terms of the user',
    name_given          varchar(255) DEFAULT NULL COMMENT 'the unique name manually set by the user,which can be null if the generated name should be used',
    name_generated      varchar(255) DEFAULT NULL COMMENT 'the generated name is saved in the database for database base unique check based on the phrases and verb,which can be overwritten by the given name',
    description         text         DEFAULT NULL COMMENT 'text that should be shown to the user in case of mouseover on the triple name',
    triple_condition_id bigint       DEFAULT NULL COMMENT 'formula_id of a formula with a boolean result; the term is only added if formula result is true',
    phrase_type_id      bigint       DEFAULT NULL COMMENT 'to link coded functionality to words e.g. to exclude measure words from a percent result',
    view_id             bigint       DEFAULT NULL COMMENT 'the default mask for this triple',
    `values`            bigint       DEFAULT NULL COMMENT 'number of values linked to the word,which gives an indication of the importance',
    inactive            smallint     DEFAULT NULL COMMENT 'true if the word is not yet active e.g. because it is moved to the prime words with a 16 bit id',
    code_id             varchar(255) DEFAULT NULL COMMENT 'to link coded functionality to a specific triple e.g. to get the values of the system configuration',
    excluded            smallint     DEFAULT NULL COMMENT 'true if a user,but not all,have removed it',
    share_type_id       smallint     DEFAULT NULL COMMENT 'to restrict the access',
    protect_id          smallint     DEFAULT NULL COMMENT 'to protect against unwanted changes'
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8
    COMMENT 'to link one word or triple with a verb to another word or triple';

--
-- table structure to save user specific changes to link one word or triple with a verb to another word or triple
--

CREATE TABLE IF NOT EXISTS user_triples
(
    triple_id           bigint           NOT NULL COMMENT 'with the user_id the internal unique primary index',
    user_id             bigint           NOT NULL COMMENT 'the changer of the triple',
    language_id         bigint NOT NULL DEFAULT 1 COMMENT 'the name used which must be unique within the terms of the user',
    triple_name         varchar(255) DEFAULT NULL COMMENT 'the name used which must be unique within the terms of the user',
    name_given          varchar(255) DEFAULT NULL COMMENT 'the unique name manually set by the user,which can be null if the generated name should be used',
    name_generated      varchar(255) DEFAULT NULL COMMENT 'the generated name is saved in the database for database base unique check based on the phrases and verb,which can be overwritten by the given name',
    description         text         DEFAULT NULL COMMENT 'text that should be shown to the user in case of mouseover on the triple name',
    triple_condition_id bigint       DEFAULT NULL COMMENT 'formula_id of a formula with a boolean result; the term is only added if formula result is true',
    phrase_type_id      bigint       DEFAULT NULL COMMENT 'to link coded functionality to words e.g. to exclude measure words from a percent result',
    view_id             bigint       DEFAULT NULL COMMENT 'the default mask for this triple',
    `values`            bigint       DEFAULT NULL COMMENT 'number of values linked to the word,which gives an indication of the importance',
    excluded            smallint     DEFAULT NULL COMMENT 'true if a user,but not all,have removed it',
    share_type_id       smallint     DEFAULT NULL COMMENT 'to restrict the access',
    protect_id          smallint     DEFAULT NULL COMMENT 'to protect against unwanted changes'
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8
    COMMENT 'to link one word or triple with a verb to another word or triple';

-- --------------------------------------------------------

--
-- Table structure to remember which phrases are stored in which table and pod
--

CREATE TABLE IF NOT EXISTS `phrase_tables`
(
    `table_id`  int(11) NOT NULL,
    `phrase_id` int(11) NOT NULL,
    `pod_url`   text,
    `active`    smallint DEFAULT NULL
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8 COMMENT ='to remember which phrases are stored in which table and pod';

-- --------------------------------------------------------
--
-- table structure the mathematical expression to calculate results based on values and results
--

CREATE TABLE IF NOT EXISTS formulas
(
    formula_id        bigint        NOT NULL COMMENT 'the internal unique primary index',
    user_id           bigint    DEFAULT NULL COMMENT 'the owner / creator of the formula',
    formula_name      varchar(255)  NOT NULL COMMENT 'the text used to search for formulas that must also be unique for all terms (words, triples, verbs and formulas)',
    formula_text      text          NOT NULL COMMENT 'the internal formula expression with the database references e.g. {f1} for formula with id 1',
    resolved_text     text          NOT NULL COMMENT 'the formula expression in user readable format as shown to the user which can include formatting for better readability',
    description       text      DEFAULT NULL COMMENT 'text to be shown to the user for mouse over; to be replaced by a language form entry',
    formula_type_id   bigint    DEFAULT NULL COMMENT 'the id of the formula type',
    all_values_needed smallint  DEFAULT NULL COMMENT 'the "calculate only if all values used in the formula exist" flag should be converted to "all needed for calculation" instead of just displaying "1"',
    last_update       timestamp DEFAULT NULL COMMENT 'time of the last calculation relevant update',
    view_id           bigint    DEFAULT NULL COMMENT 'the default mask for this formula',
    `usage`           bigint    DEFAULT NULL COMMENT 'number of results linked to this formula',
    excluded          smallint  DEFAULT NULL COMMENT 'true if a user, but not all, have removed it',
    share_type_id     smallint  DEFAULT NULL COMMENT 'to restrict the access',
    protect_id        smallint  DEFAULT NULL COMMENT 'to protect against unwanted changes'
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8
    COMMENT 'the mathematical expression to calculate results based on values and results';

--
-- table structure to save user specific changes the mathematical expression to calculate results based on values and results
--

CREATE TABLE IF NOT EXISTS user_formulas
(
    formula_id        bigint           NOT NULL COMMENT 'with the user_id the internal unique primary index',
    user_id           bigint           NOT NULL COMMENT 'the changer of the formula',
    formula_name      varchar(255) DEFAULT NULL COMMENT 'the text used to search for formulas that must also be unique for all terms (words, triples, verbs and formulas)',
    formula_text      text         DEFAULT NULL COMMENT 'the internal formula expression with the database references e.g. {f1} for formula with id 1',
    resolved_text     text         DEFAULT NULL COMMENT 'the formula expression in user readable format as shown to the user which can include formatting for better readability',
    description       text         DEFAULT NULL COMMENT 'text to be shown to the user for mouse over; to be replaced by a language form entry',
    formula_type_id   bigint       DEFAULT NULL COMMENT 'the id of the formula type',
    all_values_needed smallint     DEFAULT NULL COMMENT 'the "calculate only if all values used in the formula exist" flag should be converted to "all needed for calculation" instead of just displaying "1"',
    last_update       timestamp    DEFAULT NULL COMMENT 'time of the last calculation relevant update',
    view_id           bigint       DEFAULT NULL COMMENT 'the default mask for this formula',
    `usage`           bigint       DEFAULT NULL COMMENT 'number of results linked to this formula',
    excluded          smallint     DEFAULT NULL COMMENT 'true if a user, but not all, have removed it',
    share_type_id     smallint     DEFAULT NULL COMMENT 'to restrict the access',
    protect_id        smallint     DEFAULT NULL COMMENT 'to protect against unwanted changes'
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8
    COMMENT 'the mathematical expression to calculate results based on values and results';
-- --------------------------------------------------------

--
-- Table structure for phrase group names
--

CREATE TABLE IF NOT EXISTS `groups`
(
    `group_id`    char(112) NOT NULL,
    `group_name`  varchar(1000) DEFAULT NULL COMMENT 'if this is set a manual group for fast selection',
    `description` varchar(4000) DEFAULT NULL COMMENT 'the automatic created user readable description'
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT = 'to add a user given name using a 512 bit group id index for up to 16 16 bit phrase ids including the order';

--
-- Table structure for saving a user specific group name
--

CREATE TABLE IF NOT EXISTS `user_groups`
(
    `group_id`    char(112) NOT NULL,
    `user_id`     int(11) NOT NULL,
    `group_name`  varchar(1000) DEFAULT NULL COMMENT 'if this is set a manual group for fast selection',
    `description` varchar(4000) DEFAULT NULL COMMENT 'the automatic created user readable description'
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='to reduce the number of value to term links';

--
-- Table structure for phrase group names of up to four prime phrases
--

CREATE TABLE IF NOT EXISTS `groups_prime`
(
    `group_id`    int(11) NOT NULL,
    `group_name`  varchar(1000) DEFAULT NULL COMMENT 'if this is set a manual group for fast selection',
    `description` varchar(4000) DEFAULT NULL COMMENT 'the automatic created user readable description'
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT = 'to add a user given name using a 64 bit bigint group id index for up to four 16 bit phrase ids including the order';

--
-- Table structure for saving a user specific group name
--

CREATE TABLE IF NOT EXISTS `user_groups_prime`
(
    `group_id`    int(11) NOT NULL,
    `user_id`     int(11) NOT NULL,
    `group_name`  varchar(1000) DEFAULT NULL COMMENT 'if this is set a manual group for fast selection',
    `description` varchar(4000) DEFAULT NULL COMMENT 'the automatic created user readable description'
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT = 'to link the user specific name to the group';

--
-- Table structure for phrase group names of more than 16 phrases
--

CREATE TABLE IF NOT EXISTS `groups_big`
(
    `group_id`    text NOT NULL,
    `group_name`  varchar(1000) DEFAULT NULL COMMENT 'if this is set a manual group for fast selection',
    `description` varchar(4000) DEFAULT NULL COMMENT 'the automatic created user readable description'
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT = 'to add a user given name using text group id index for an almost unlimited number of phrase ids including the order';

--
-- Table structure for saving a user specific group name for more than 16 phrases
--

CREATE TABLE IF NOT EXISTS `user_groups_big`
(
    `group_id`    text NOT NULL,
    `user_id`     int(11) NOT NULL,
    `group_name`  varchar(1000) DEFAULT NULL COMMENT 'if this is set a manual group for fast selection',
    `description` varchar(4000) DEFAULT NULL COMMENT 'the automatic created user readable description'
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT = 'for saving a user specific group name for more than 16 phrases';

-- --------------------------------------------------------

--
-- Table structure to link phrases to a group
-- TODO deprecate and use like on group_id instead
--

CREATE TABLE IF NOT EXISTS `group_links`
(
    `group_id`  char(112) NOT NULL,
    `phrase_id` int(11) NOT NULL
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT = 'link phrases to a phrase group for database based selections';

--
-- Table structure to store user specific ex- or includes of single link of phrases to groups
--

CREATE TABLE IF NOT EXISTS `user_group_links`
(
    `group_id`  char(112) NOT NULL,
    `phrase_id` int(11) NOT NULL,
    `user_id`   int(11) DEFAULT NULL,
    `excluded`  smallint DEFAULT NULL
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT = 'to store user specific ex- or includes of single link of phrases to groups';

--
-- Table structure to link phrases to a group
-- TODO deprecate and use like on binary format of group_id instead
--

CREATE TABLE IF NOT EXISTS `group_prime_links`
(
    `group_id`  int(11) NOT NULL,
    `phrase_id` int(11) NOT NULL
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT = 'link phrases to a short phrase group for database based selections';

--
-- Table structure to store user specific ex- or includes of single link of phrases to groups
--

CREATE TABLE IF NOT EXISTS `user_group_prime_links`
(
    `group_id`  int(11) NOT NULL,
    `phrase_id` int(11) NOT NULL,
    `user_id`   int(11) DEFAULT NULL,
    `excluded`  smallint DEFAULT NULL
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT = 'user specific link to groups with up to four prime phrase';

--
-- Table structure to link up more than 16 phrases to a group
-- TODO deprecate and use like on group_id instead
--

CREATE TABLE IF NOT EXISTS `group_big_links`
(
    `group_id`  text NOT NULL,
    `phrase_id` int(11) NOT NULL
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT = 'link phrases to a short phrase group for database based selections';

--
-- Table structure to store user specific ex- or includes of single link of phrases to groups
--

CREATE TABLE IF NOT EXISTS `user_group_big_links`
(
    `group_id`  text NOT NULL,
    `phrase_id` int(11) NOT NULL,
    `user_id`   int(11) DEFAULT NULL,
    `excluded`  smallint DEFAULT NULL
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT = 'user specific link to groups with up to four prime phrase';

-- --------------------------------------------------------

--
-- table structure to link predefined behaviour to a source
--

CREATE TABLE IF NOT EXISTS source_types
(
    source_type_id bigint          NOT NULL COMMENT 'the internal unique primary index',
    type_name     varchar(255)     NOT NULL COMMENT 'the unique type name as shown to the user and used for the selection',
    code_id       varchar(255) DEFAULT NULL COMMENT 'this id text is unique for all code links,is used for system im- and export and is used to link coded functionality to a specific word e.g. to get the values of the system configuration',
    description   text         DEFAULT NULL COMMENT 'text to explain the type to the user as a tooltip; to be replaced by a language form entry'
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8
    COMMENT 'to link predefined behaviour to a source';


-- --------------------------------------------------------

--
-- table structure for the original sources for the numeric, time and geo values
--

CREATE TABLE IF NOT EXISTS sources (
    source_id      bigint           NOT NULL COMMENT 'the internal unique primary index',
    user_id        bigint       DEFAULT NULL COMMENT 'the owner / creator of the source',
    source_name    varchar(255)     NOT NULL COMMENT 'the unique name of the source used e.g. as the primary search key',
    description    text DEFAULT         NULL COMMENT 'the user specific description of the source for mouse over helps',
    source_type_id bigint DEFAULT       NULL COMMENT 'link to the source type',
    `url`          text DEFAULT         NULL COMMENT 'the url of the source',
    code_id        varchar(100) DEFAULT NULL COMMENT 'to select sources used by this program',
    excluded       smallint     DEFAULT NULL COMMENT 'true if a user,but not all,have removed it',
    share_type_id  smallint     DEFAULT NULL COMMENT 'to restrict the access',
    protect_id     smallint     DEFAULT NULL COMMENT 'to protect against unwanted changes'
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8
    COMMENT 'for the original sources for the numeric,time and geo values';

--
-- table structure to save user specific changes for the original sources for the numeric, time and geo values
--

CREATE TABLE IF NOT EXISTS user_sources (
    source_id      bigint           NOT NULL COMMENT 'with the user_id the internal unique primary index',
    user_id        bigint           NOT NULL COMMENT 'the changer of the source',
    source_name    varchar(255) DEFAULT NULL COMMENT 'the unique name of the source used e.g. as the primary search key',
    description    text         DEFAULT NULL COMMENT 'the user specific description of the source for mouse over helps',
    source_type_id bigint       DEFAULT NULL COMMENT 'link to the source type',
    `url`          text         DEFAULT NULL COMMENT 'the url of the source',
    code_id        varchar(100) DEFAULT NULL COMMENT 'to select sources used by this program',
    excluded       smallint     DEFAULT NULL COMMENT 'true if a user,but not all,have removed it',
    share_type_id  smallint     DEFAULT NULL COMMENT 'to restrict the access',
    protect_id     smallint     DEFAULT NULL COMMENT 'to protect against unwanted changes'
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8
    COMMENT 'for the original sources for the numeric,time and geo values';

--
-- Table structure for table`source_values`
--

CREATE TABLE IF NOT EXISTS `source_values`
(
    `group_id`     int(11) NOT NULL,
    `source_id`    int(11) NOT NULL,
    `user_id`      int(11) NOT NULL,
    `source_value` double  NOT NULL
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='one user can add different value, which should be the same, but are different  ';

--
-- Table structure for table`import_source`
--

CREATE TABLE IF NOT EXISTS `import_source`
(
    `import_source_id` int(11)      NOT NULL,
    `name`             varchar(100) NOT NULL,
    `import_type`      int(11)      NOT NULL,
    `word_id`          int(11)      NOT NULL COMMENT 'the name as a term'
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='many replace by a term';

-- --------------------------------------------------------

--
-- Table structure for table`ref_types`
--

CREATE TABLE IF NOT EXISTS `ref_types`
(
    `ref_type_id` int(11)      NOT NULL,
    `type_name`   varchar(200) NOT NULL,
    `code_id`     varchar(100) NOT NULL,
    `description` text         NOT NULL,
    `base_url`    text         NOT NULL
) ENGINE = InnoDB
  AUTO_INCREMENT = 5
  DEFAULT CHARSET = utf8;

--
-- Table structure for table`refs`
--

CREATE TABLE IF NOT EXISTS `refs`
(
    `ref_id`       int(11)      NOT NULL,
    `user_id`      bigint       NOT NULL,
    `phrase_id`    int(11)      NOT NULL,
    `external_key` varchar(250) NOT NULL,
    `ref_type_id`  int(11)      NOT NULL,
    `source_id`    int(11)      DEFAULT NULL,
    `url`          text         DEFAULT NULL,
    `description`  text         DEFAULT NULL,
    `excluded`     tinyint(4)   DEFAULT NULL
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

--
-- Table structure for table`user_refs`
--

CREATE TABLE IF NOT EXISTS `user_refs`
(
    `ref_id`        int(11) NOT NULL,
    `user_id`       int(11) NOT NULL,
    `url`           text         DEFAULT NULL,
    `description`   text         DEFAULT NULL,
    `excluded`      tinyint(4)   DEFAULT NULL
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;


-- --------------------------------------------------------

--
-- Table structure for public values related up to four prime phrase that have never changed the owner, does not have a description and are rarely updated
--

CREATE TABLE IF NOT EXISTS `values_standard_prime`
(
    `group_id`        int(11)   NOT NULL COMMENT 'the prime index to find the value',
    `numeric_value`   double    NOT NULL,
    `source_id`       int(11)   DEFAULT NULL COMMENT 'the prime source'
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT = 'for public unprotected values related up to four prime phrase that have never changed the owner, does not have a description and are rarely updated';


--
-- Table structure for public values that have never changed the owner, does not have a description and are rarely updated
--

CREATE TABLE IF NOT EXISTS `values_standard`
(
    `group_id`        char(112) NOT NULL COMMENT 'the prime index to find the value',
    `numeric_value`   double    NOT NULL,
    `source_id`       int(11)   DEFAULT NULL COMMENT 'the prime source'
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT = 'for public unprotected values that have never changed the owner, does not have a description and are rarely updated';

-- --------------------------------------------------------

--
-- Table structure for numeric values related to up to 16 phrases
--

CREATE TABLE IF NOT EXISTS `values`
(
    `group_id`        char(112) NOT NULL COMMENT 'the prime index to find the value',
    `numeric_value`   double    NOT NULL,
    `user_id`         int(11)            DEFAULT NULL COMMENT 'the owner / creator of the value',
    `source_id`       int(11)            DEFAULT NULL,
    `description`     text COMMENT 'temp field used during dev phase for easy value to trm assigns',
    `excluded`        tinyint(4)         DEFAULT NULL COMMENT 'the default exclude setting for most users',
    `share_type_id`   smallint           DEFAULT NULL,
    `protect_id`      int(11)   NOT NULL DEFAULT '1',
    `last_update`     timestamp NULL     DEFAULT NULL COMMENT 'for fast recalculation'
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8 COMMENT ='long list';

--
-- Table structure for table `user_values`
--

CREATE TABLE IF NOT EXISTS `user_values`
(
    `group_id`      char(112) NOT NULL COMMENT 'the prime index to find the value',
    `user_id`       int(11)   NOT NULL,
    `numeric_value` double         DEFAULT NULL,
    `source_id`     int(11)        DEFAULT NULL,
    `excluded`      tinyint(4)     DEFAULT NULL,
    `share_type_id` int(11)        DEFAULT NULL,
    `protect_id`    int(11)        DEFAULT NULL,
    `last_update`   timestamp NULL DEFAULT NULL COMMENT 'for fast calculation of the updates'
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='for quick access to the user specific values';

-- --------------------------------------------------------

--
-- Table structure for numeric values related to up to 16 phrases
--

CREATE TABLE IF NOT EXISTS `values_prime`
(
    `group_id`        char(112) NOT NULL COMMENT 'the prime index to find the value',
    `numeric_value`   double    NOT NULL,
    `user_id`         int(11)            DEFAULT NULL COMMENT 'the owner / creator of the value',
    `source_id`       int(11)            DEFAULT NULL,
    `description`     text COMMENT 'temp field used during dev phase for easy value to trm assigns',
    `excluded`        tinyint(4)         DEFAULT NULL COMMENT 'the default exclude setting for most users',
    `last_update`     timestamp NULL     DEFAULT NULL COMMENT 'for fast recalculation',
    `share_type_id`   smallint           DEFAULT NULL,
    `protect_id`      int(11)   NOT NULL DEFAULT '1'
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8 COMMENT ='long list';

--
-- Table structure for table `user_values`
--

CREATE TABLE IF NOT EXISTS `user_values_prime`
(
    `group_id`      int(11)   NOT NULL,
    `user_id`       int(11)   NOT NULL,
    `numeric_value` double         DEFAULT NULL,
    `source_id`     int(11)        DEFAULT NULL,
    `excluded`      tinyint(4)     DEFAULT NULL,
    `share_type_id` int(11)        DEFAULT NULL,
    `protect_id`    int(11)        DEFAULT NULL,
    `last_update`   timestamp NULL DEFAULT NULL COMMENT 'for fast calculation of the updates'
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='for quick access to the user specific values';

-- --------------------------------------------------------

--
-- Table structure for numeric values related to more than 16 phrases
--

CREATE TABLE IF NOT EXISTS `values_big`
(
    `group_id`        text NOT NULL COMMENT 'the big index to find the value',
    `numeric_value`   double    NOT NULL,
    `user_id`         int(11)            DEFAULT NULL COMMENT 'the owner / creator of the value',
    `source_id`       int(11)            DEFAULT NULL,
    `description`     text COMMENT 'temp field used during dev phase for easy value to trm assigns',
    `excluded`        tinyint(4)         DEFAULT NULL COMMENT 'the default exclude setting for most users',
    `last_update`     timestamp NULL     DEFAULT NULL COMMENT 'for fast recalculation',
    `share_type_id`   smallint           DEFAULT NULL,
    `protect_id`      int(11)   NOT NULL DEFAULT '1'
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8 COMMENT ='long list';

--
-- Table structure to store the user specific changes of values related to more than 16 phrases
--

CREATE TABLE IF NOT EXISTS `user_values_big`
(
    `group_id`      text   NOT NULL,
    `user_id`       int(11)   NOT NULL,
    `numeric_value` double         DEFAULT NULL,
    `source_id`     int(11)        DEFAULT NULL,
    `excluded`      tinyint(4)     DEFAULT NULL,
    `share_type_id` int(11)        DEFAULT NULL,
    `protect_id`    int(11)        DEFAULT NULL,
    `last_update`   timestamp NULL DEFAULT NULL COMMENT 'for fast calculation of the updates'
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='for quick access to the user specific values';

-- --------------------------------------------------------

-- .....

-- --------------------------------------------------------

--
-- Table structure for table`value_time_series`
--

CREATE TABLE IF NOT EXISTS `value_time_series`
(
    `value_time_series_id` int(11)   NOT NULL,
    `user_id`              int(11)   NOT NULL,
    `source_id`            int(11)        DEFAULT NULL,
    `phrase_group_id`      int(11)   NOT NULL,
    `excluded`             tinyint(4)     DEFAULT NULL,
    `share_type_id`        int(11)        DEFAULT NULL,
    `protect_id`           int(11)   NOT NULL,
    `last_update`          timestamp NULL DEFAULT NULL
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='common parameters for a list of intraday values';

--
-- Table structure for table`user_value_time_series`
--

CREATE TABLE IF NOT EXISTS `user_value_time_series`
(
    `value_time_series_id` int(11)   NOT NULL,
    `user_id`              int(11)   NOT NULL,
    `source_id`            int(11)        DEFAULT NULL,
    `excluded`             tinyint(4)     DEFAULT NULL,
    `share_type_id`        int(11)        DEFAULT NULL,
    `protect_id`           int(11)   NOT NULL,
    `last_update`          timestamp NULL DEFAULT NULL
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='common parameters for a user specific list of intraday values';

--
-- Table structure for table`value_ts_data`
--

CREATE TABLE IF NOT EXISTS `value_ts_data`
(
    `value_time_series_id` int(11)  NOT NULL,
    `val_time`             datetime NOT NULL,
    `number`               float    NOT NULL
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='for efficient saving of daily or intraday values';

-- --------------------------------------------------------

-- .....

-- --------------------------------------------------------

--
-- Table structure for table`formula_elements`
--

CREATE TABLE IF NOT EXISTS `formula_elements`
(
    `formula_element_id`      int(11) NOT NULL,
    `formula_id`              int(11) NOT NULL,
    `user_id`                 int(11) NOT NULL,
    `order_nbr`               int(11) NOT NULL,
    `formula_element_type_id` int(11) NOT NULL,
    `ref_id`                  int(11)      DEFAULT NULL COMMENT 'either a term, verb or formula id',
    `resolved_text`           varchar(200) DEFAULT NULL
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8 COMMENT ='cache for fast update of formula resolved text';

-- --------------------------------------------------------

--
-- Table structure for table`formula_links`
--

CREATE TABLE IF NOT EXISTS `formula_links`
(
    `formula_link_id` int(11) NOT NULL,
    `user_id`         int(11)    DEFAULT NULL,
    `formula_id`      int(11) NOT NULL,
    `phrase_id`       int(11) NOT NULL,
    `link_type_id`    int(11)    DEFAULT NULL,
    `order_nbr`       int(11)    DEFAULT NULL,
    `excluded`        tinyint(4) DEFAULT NULL
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8 COMMENT ='if the term pattern of a value matches this term pattern ';

-- --------------------------------------------------------

--
-- Table structure for table`formula_link_types`
--

CREATE TABLE IF NOT EXISTS `formula_link_types`
(
    `formula_link_type_id` int(11)      NOT NULL,
    `type_name`            varchar(200) NOT NULL,
    `code_id`              varchar(100)          DEFAULT NULL,
    `formula_id`           int(11)      NOT NULL,
    `phrase_type_id`       int(11)      NOT NULL DEFAULT 1,
    `link_type_id`         int(11)      NOT NULL,
    `description`          text CHARACTER SET ucs2
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8;

-- --------------------------------------------------------

--
-- table structure to assign predefined behaviour to formulas
--

CREATE TABLE IF NOT EXISTS formula_types
(
    formula_type_id bigint           NOT NULL COMMENT 'the internal unique primary index',
    type_name       varchar(255)     NOT NULL COMMENT 'the unique type name as shown to the user and used for the selection',
    code_id         varchar(255) DEFAULT NULL COMMENT 'this id text is unique for all code links,is used for system im- and export and is used to link coded functionality to a specific word e.g. to get the values of the system configuration',
    description     text         DEFAULT NULL COMMENT 'text to explain the type to the user as a tooltip; to be replaced by a language form entry'
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8
    COMMENT 'to assign predefined behaviour to formulas';

-- --------------------------------------------------------

--
-- Table structure for table`results`
--

CREATE TABLE IF NOT EXISTS `results`
(
    `group_id`        int(11)   NOT NULL,
    `formula_id`      int(11)   NOT NULL,
    `user_id`         int(11)   DEFAULT NULL,
    `source_group_id` int(11)   DEFAULT NULL,
    `result`          double    NOT NULL,
    `last_update`     timestamp NULL DEFAULT NULL COMMENT 'time of last value update mainly used for recovery in case of inconsistencies, empty in case this value is dirty'
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8 COMMENT ='table to cache the formula results';

-- --------------------------------------------------------
--
-- table structure to add a user given name using a 512-bit group id index for up to 16 32-bit phrase ids including the order
--

CREATE TABLE IF NOT EXISTS `groups` (
    group_id    char(112)     NOT NULL COMMENT 'the 512-bit prime index to find the group',
    user_id     bigint    DEFAULT NULL COMMENT 'the owner / creator of the group',
    group_name  text      DEFAULT NULL COMMENT 'the user specific group name which can contain the phrase names in a different order to display the group (does not need to be unique)',
    description text      DEFAULT NULL COMMENT 'the user specific description for mouse over helps'
) ENGINE = InnoDB DEFAULT CHARSET = utf8 COMMENT 'to add a user given name using a 512-bit group id index for up to 16 32-bit phrase ids including the order';

--
-- table structure to save user specific changes to add a user given name using a 512-bit group id index for up to 16 32-bit phrase ids including the order
--

CREATE TABLE IF NOT EXISTS user_groups (
    group_id    char(112)     NOT NULL COMMENT 'the 512-bit prime index to find the user group',
    user_id     bigint        NOT NULL COMMENT 'the changer of the group',
    group_name  text      DEFAULT NULL COMMENT 'the user specific group name which can contain the phrase names in a different order to display the group (does not need to be unique)',
    description text      DEFAULT NULL COMMENT 'the user specific description for mouse over helps'
) ENGINE = InnoDB DEFAULT CHARSET = utf8 COMMENT 'to add a user given name using a 512-bit group id index for up to 16 32-bit phrase ids including the order';

--
-- table structure to add a user given name using a 64-bit group id index for up to four 16-bit phrase ids including the order
--

CREATE TABLE IF NOT EXISTS groups_prime (
    group_id    bigint     NOT NULL COMMENT 'the 64-bit prime index to find the group',
    user_id     bigint DEFAULT NULL COMMENT 'the owner / creator of the group',
    group_name  text   DEFAULT NULL COMMENT 'the user specific group name which can contain the phrase names in a different order to display the group (does not need to be unique)',
    description text   DEFAULT NULL COMMENT 'the user specific description for mouse over helps'
) ENGINE = InnoDB DEFAULT CHARSET = utf8 COMMENT 'to add a user given name using a 64-bit group id index for up to four 16-bit phrase ids including the order';

--
-- table structure to save user specific changes to add a user given name using a 64-bit group id index for up to four 16-bit phrase ids including the order
--

CREATE TABLE IF NOT EXISTS user_groups_prime (
    group_id    bigint     NOT NULL COMMENT 'the 64-bit prime index to find the user group',
    user_id     bigint     NOT NULL COMMENT 'the changer of the group',
    group_name  text   DEFAULT NULL COMMENT 'the user specific group name which can contain the phrase names in a different order to display the group (does not need to be unique)',
    description text   DEFAULT NULL COMMENT 'the user specific description for mouse over helps'
) ENGINE = InnoDB DEFAULT CHARSET = utf8 COMMENT 'to add a user given name using a 64-bit group id index for up to four 16-bit phrase ids including the order';

--
-- table structure to add a user given name using a group id index with a variable length for more than 16 32-bit phrase ids including the order
--

CREATE TABLE IF NOT EXISTS groups_big (
    group_id    char(255)     NOT NULL COMMENT 'the variable text index to find group',
    user_id     bigint    DEFAULT NULL COMMENT 'the owner / creator of the group',
    group_name  text      DEFAULT NULL COMMENT 'the user specific group name which can contain the phrase names in a different order to display the group (does not need to be unique)',
    description text      DEFAULT NULL COMMENT 'the user specific description for mouse over helps'
) ENGINE = InnoDB DEFAULT CHARSET = utf8 COMMENT 'to add a user given name using a group id index with a variable length for more than 16 32-bit phrase ids including the order';

--
-- table structure to save user specific changes to add a user given name using a group id index with a variable length for more than 16 32-bit phrase ids including the order
--

CREATE TABLE IF NOT EXISTS user_groups_big (
    group_id    char(255)     NOT NULL COMMENT 'the text index for more than 16 phrases to find the group',
    user_id     bigint        NOT NULL COMMENT 'the changer of the group',
    group_name  text      DEFAULT NULL COMMENT 'the user specific group name which can contain the phrase names in a different order to display the group (does not need to be unique)',
    description text      DEFAULT NULL COMMENT 'the user specific description for mouse over helps'
) ENGINE = InnoDB DEFAULT CHARSET = utf8 COMMENT 'to add a user given name using a group id index with a variable length for more than 16 32-bit phrase ids including the order';

-- --------------------------------------------------------

--
-- Table structure for table`phrase_groups`
--

CREATE TABLE IF NOT EXISTS `phrase_groups`
(
    `phrase_group_id`   int(11) NOT NULL,
    `phrase_group_name` varchar(1000) DEFAULT NULL COMMENT 'if this is set a manual group for fast selection',
    `auto_description`  varchar(4000) DEFAULT NULL COMMENT 'the automatic created user readable description',
    `word_ids`          varchar(255)  DEFAULT NULL,
    `triple_ids`        varchar(255)  DEFAULT NULL COMMENT 'one field link to the table term_links',
    `id_order`          varchar(512)  DEFAULT NULL COMMENT 'the phrase ids in the order that the user wants to see them'
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8 COMMENT ='to reduce the number of value to term links';

-- --------------------------------------------------------

--
-- Stand-in structure for view`phrase_groups_phrase_links`
--
CREATE TABLE IF NOT EXISTS `phrase_groups_phrase_links`
(
    `phrase_groups_phrase_link_id` int(11),
    `phrase_group_id`             int(11),
    `phrase_id`                   bigint(20)
);
-- --------------------------------------------------------

--
-- Table structure for table`phrase_group_word_links`
--

CREATE TABLE IF NOT EXISTS `phrase_group_word_links`
(
    `phrase_group_word_link_id` int(11) NOT NULL,
    `phrase_group_id`           int(11) NOT NULL,
    `word_id`                   int(11) NOT NULL
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8 COMMENT ='link words to a phrase_group for database based selections';

-- --------------------------------------------------------

--
-- Table structure for table`phrase_group_triple_links`
--

CREATE TABLE IF NOT EXISTS `phrase_group_triple_links`
(
    `phrase_group_triple_link_id` int(11) NOT NULL,
    `phrase_group_id`             int(11) NOT NULL,
    `triple_id`                   int(11) NOT NULL
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='link phrases to a phrase_group for database based selections';

-- --------------------------------------------------------

-- --------------------------------------------------------

--
-- Table structure for table`user_formulas`
--

CREATE TABLE IF NOT EXISTS `user_formulas`
(
    `formula_id`        int(11)   NOT NULL,
    `user_id`           int(11)   NOT NULL,
    `formula_name`      varchar(200)   DEFAULT NULL,
    `formula_text`      text,
    `resolved_text`     text,
    `description`       text,
    `formula_type_id`   int(11)        DEFAULT NULL,
    `all_values_needed` tinyint(4)     DEFAULT NULL,
    `usage`             int(11)        DEFAULT NULL,
    `share_type_id`     int(11)        DEFAULT NULL,
    `protect_id`        int(11)        DEFAULT NULL,
    `last_update`       timestamp NULL DEFAULT NULL,
    `excluded`          tinyint(4)     DEFAULT NULL
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

-- --------------------------------------------------------

--
-- Table structure for table`user_formula_links`
--

CREATE TABLE IF NOT EXISTS `user_formula_links`
(
    `formula_link_id` int(11) NOT NULL,
    `user_id`         int(11) NOT NULL,
    `link_type_id`    int(11)    DEFAULT NULL,
    `excluded`        tinyint(4) DEFAULT NULL
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='if the term pattern of a value matches this term pattern ';

-- --------------------------------------------------------

-- --------------------------------------------------------

--
-- Table structure for table`user_phrase_groups`
--

CREATE TABLE IF NOT EXISTS `user_phrase_groups`
(
    `phrase_group_id`   int(11) NOT NULL,
    `user_id`           int(11) NOT NULL,
    `phrase_group_name` varchar(1000) DEFAULT NULL COMMENT 'if this is set a manual group for fast selection',
    `auto_description`  varchar(4000) DEFAULT NULL COMMENT 'the automatic created user readable description',
    `id_order`          varchar(512)  DEFAULT NULL COMMENT 'the phrase ids in the order that the user wants to see them'
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='to reduce the number of value to term links';

-- --------------------------------------------------------

--
-- Stand-in structure for view`user_phrase_groups_phrase_links`
--
CREATE TABLE IF NOT EXISTS `user_phrase_groups_phrase_links`
(
    `phrase_groups_phrase_link_id` int(11),
    `user_id`                     int(11),
    `excluded`                    tinyint(4)
);
-- --------------------------------------------------------

--
-- Table structure for table`user_phrase_group_word_links`
--

CREATE TABLE IF NOT EXISTS `user_phrase_group_word_links`
(
    `phrase_group_word_link_id` int(11) NOT NULL,
    `user_id`                   int(11)    DEFAULT NULL,
    `excluded`                  tinyint(4) DEFAULT NULL
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='view for fast group selection based on a triple';

-- --------------------------------------------------------

--
-- Table structure for table`user_phrase_group_triple_links`
--

CREATE TABLE IF NOT EXISTS `user_phrase_group_triple_links`
(
    `phrase_group_triple_link_id` int(11) NOT NULL,
    `user_id`                     int(11)    DEFAULT NULL,
    `excluded`                    tinyint(4) DEFAULT NULL
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='view for fast group selection based on a triple';

-- --------------------------------------------------------

--
-- table structure to store all user interfaces entry points
--

CREATE TABLE IF NOT EXISTS views
(
    view_id       bigint           NOT NULL COMMENT 'the internal unique primary index',
    user_id       bigint       DEFAULT NULL COMMENT 'the owner / creator of the view',
    view_name     varchar(255)     NOT NULL COMMENT 'the name of the view used for searching',
    description   text         DEFAULT NULL COMMENT 'to explain the view to the user with a mouse over text; to be replaced by a language form entry',
    view_type_id  bigint       DEFAULT NULL COMMENT 'to link coded functionality to views e.g. to use a view for the startup page',
    code_id       varchar(255) DEFAULT NULL COMMENT 'to link coded functionality to a specific view e.g. define the internal system views',
    excluded      smallint     DEFAULT NULL COMMENT 'true if a user,but not all,have removed it',
    share_type_id smallint     DEFAULT NULL COMMENT 'to restrict the access',
    protect_id    smallint     DEFAULT NULL COMMENT 'to protect against unwanted changes'
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8
    COMMENT 'to store all user interfaces entry points';

--
-- table structure to save user specific changes to store all user interfaces entry points
--

CREATE TABLE IF NOT EXISTS user_views
(
    view_id       bigint NOT NULL              COMMENT 'with the user_id the internal unique primary index',
    user_id       bigint NOT NULL              COMMENT 'the changer of the view',
    language_id   bigint NOT NULL DEFAULT 1    COMMENT 'the name of the view used for searching',
    view_name     varchar(255)    DEFAULT NULL COMMENT 'the name of the view used for searching',
    description   text            DEFAULT NULL COMMENT 'to explain the view to the user with a mouse over text; to be replaced by a language form entry',
    view_type_id  bigint          DEFAULT NULL COMMENT 'to link coded functionality to views e.g. to use a view for the startup page',
    excluded      smallint        DEFAULT NULL COMMENT 'true if a user,but not all,have removed it',
    share_type_id smallint        DEFAULT NULL COMMENT 'to restrict the access',
    protect_id    smallint        DEFAULT NULL COMMENT 'to protect against unwanted changes'
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8
    COMMENT 'to store all user interfaces entry points';

-- --------------------------------------------------------

--
-- table structure for the single components of a view
--

CREATE TABLE IF NOT EXISTS components
(
    component_id           bigint           NOT NULL COMMENT 'the internal unique primary index',
    user_id                bigint       DEFAULT NULL COMMENT 'the owner / creator of the component',
    component_name         varchar(255)     NOT NULL COMMENT 'the unique name used to select a component by the user',
    description            text         DEFAULT NULL COMMENT 'to explain the view component to the user with a mouse over text; to be replaced by a language form entry',
    component_type_id      bigint       DEFAULT NULL COMMENT 'to select the predefined functionality',
    word_id_row            bigint       DEFAULT NULL COMMENT 'for a tree the related value the start node',
    formula_id             bigint       DEFAULT NULL COMMENT 'used for type 6',
    word_id_col            bigint       DEFAULT NULL COMMENT 'to define the type for the table columns',
    word_id_col2           bigint       DEFAULT NULL COMMENT 'e.g. "quarter" to show the quarters between the year columns or the second axis of a chart',
    linked_component_id    bigint       DEFAULT NULL COMMENT 'to link this component to another component',
    component_link_type_id bigint       DEFAULT NULL COMMENT 'to define how this entry links to the other entry',
    link_type_id           bigint       DEFAULT NULL COMMENT 'e.g. for type 4 to select possible terms',
    code_id                varchar(255) DEFAULT NULL COMMENT 'used for system components to select the component by the program code',
    ui_msg_code_id         varchar(255) DEFAULT NULL COMMENT 'used for system components the id to select the language specific user interface message e.g. "add word"',
    excluded               smallint     DEFAULT NULL COMMENT 'true if a user, but not all, have removed it',
    share_type_id          smallint     DEFAULT NULL COMMENT 'to restrict the access',
    protect_id             smallint     DEFAULT NULL COMMENT 'to protect against unwanted changes'
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8
    COMMENT 'for the single components of a view';

--
-- table structure to save user specific changes for the single components of a view
--

CREATE TABLE IF NOT EXISTS user_components
(
    component_id           bigint       NOT     NULL COMMENT 'with the user_id the internal unique primary index',
    user_id                bigint       NOT     NULL COMMENT 'the changer of the component',
    component_name         varchar(255) DEFAULT NULL COMMENT 'the unique name used to select a component by the user',
    description            text         DEFAULT NULL COMMENT 'to explain the view component to the user with a mouse over text; to be replaced by a language form entry',
    component_type_id      bigint       DEFAULT NULL COMMENT 'to select the predefined functionality',
    word_id_row            bigint       DEFAULT NULL COMMENT 'for a tree the related value the start node',
    formula_id             bigint       DEFAULT NULL COMMENT 'used for type 6',
    word_id_col            bigint       DEFAULT NULL COMMENT 'to define the type for the table columns',
    word_id_col2           bigint       DEFAULT NULL COMMENT 'e.g. "quarter" to show the quarters between the year columns or the second axis of a chart',
    linked_component_id    bigint       DEFAULT NULL COMMENT 'to link this component to another component',
    component_link_type_id bigint       DEFAULT NULL COMMENT 'to define how this entry links to the other entry',
    link_type_id           bigint       DEFAULT NULL COMMENT 'e.g. for type 4 to select possible terms',
    excluded               smallint     DEFAULT NULL COMMENT 'true if a user, but not all, have removed it',
    share_type_id          smallint     DEFAULT NULL COMMENT 'to restrict the access',
    protect_id             smallint     DEFAULT NULL COMMENT 'to protect against unwanted changes'
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8
    COMMENT 'for the single components of a view';

-- --------------------------------------------------------

--
-- Table structure for table`component_links`
--

CREATE TABLE IF NOT EXISTS `component_links`
(
    `component_link_id` int(11) NOT NULL,
    `user_id`                int(11) NOT NULL,
    `view_id`                int(11) NOT NULL,
    `component_id`      int(11) NOT NULL,
    `order_nbr`              int(11) NOT NULL,
    `position_type`          int(11) NOT NULL DEFAULT '2' COMMENT '1=side, 2 =below',
    `excluded`               tinyint(4)       DEFAULT NULL,
    `share_type_id`          smallint         DEFAULT NULL,
    `protect_id`             smallint         DEFAULT NULL
) ENGINE = InnoDB
  AUTO_INCREMENT = 25
  DEFAULT CHARSET = utf8 COMMENT ='A named mask entry can be used in several masks e.g. the company name';

-- --------------------------------------------------------

--
-- Table structure for table`component_link_types`
--

CREATE TABLE IF NOT EXISTS `component_link_types`
(
    `component_link_type_id` int(11)      NOT NULL,
    `type_name`                   varchar(200) NOT NULL,
    `code_id`                     varchar(50)  NOT NULL
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

-- --------------------------------------------------------

--
-- Table structure for table`component_position_types`
--

CREATE TABLE IF NOT EXISTS `component_position_types`
(
    `component_position_type_id` int(11)      NOT NULL,
    `type_name`                       varchar(100) NOT NULL,
    `description`                     text         NOT NULL,
    `code_id`                         varchar(50)  NOT NULL
) ENGINE = InnoDB
  AUTO_INCREMENT = 3
  DEFAULT CHARSET = utf8 COMMENT ='sideways or down';

-- --------------------------------------------------------

--
-- Table structure for table`component_types`
--

CREATE TABLE IF NOT EXISTS `component_types`
(
    `component_type_id` int(11)      NOT NULL,
    `type_name`              varchar(100) NOT NULL,
    `description`            text DEFAULT NULL,
    `code_id`                varchar(100) NOT NULL
) ENGINE = InnoDB
  AUTO_INCREMENT = 17
  DEFAULT CHARSET = utf8 COMMENT ='fixed text, term or formula result';

-- --------------------------------------------------------

-- --------------------------------------------------------

--
-- Table structure for table`user_component_links`
--

CREATE TABLE IF NOT EXISTS `user_component_links`
(
    `component_link_id` int(11) NOT NULL,
    `user_id`                int(11) NOT NULL,
    `order_nbr`              int(11)    DEFAULT NULL,
    `position_type`          int(11)    DEFAULT NULL,
    `excluded`               tinyint(4) DEFAULT NULL,
    `share_type_id`          smallint   DEFAULT NULL,
    `protect_id`             smallint   DEFAULT NULL
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;
-- --------------------------------------------------------

--
-- Table structure for table`value_formula_links`
--

CREATE TABLE IF NOT EXISTS `value_formula_links`
(
    `value_formula_link_id` int(11) NOT NULL,
    `group_id`              int(11) DEFAULT NULL,
    `formula_id`            int(11) DEFAULT NULL,
    `user_id`               int(11) DEFAULT NULL,
    `condition_formula_id`  int(11) DEFAULT NULL COMMENT 'if true or 1  to formula is preferred',
    `comment`               text
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8 COMMENT ='used to select if a saved value should be used or a calculated value';

-- --------------------------------------------------------

--
-- Table structure for table`value_phrase_links`
--

CREATE TABLE IF NOT EXISTS `value_phrase_links`
(
    `value_phrase_link_id` int(11) NOT NULL,
    `user_id`              int(11) DEFAULT NULL,
    `group_id`             int(11) NOT NULL,
    `phrase_id`            int(11) NOT NULL,
    `weight`               double  DEFAULT NULL,
    `link_type_id`         int(11) DEFAULT NULL,
    `condition_formula_id` int(11) DEFAULT NULL COMMENT 'formula_id of a formula with a boolean result; the term is only added if formula result is true'
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8 COMMENT ='link single word or triple to a value only for fast search';

-- --------------------------------------------------------

--
-- Table structure for table`value_relations`
--

CREATE TABLE IF NOT EXISTS `value_relations`
(
    `value_link_id` int(11) NOT NULL,
    `from_value`    int(11) NOT NULL,
    `to_value`      int(11) NOT NULL,
    `link_type_id`  int(11) NOT NULL
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='to link two values directly; maybe not used';

-- --------------------------------------------------------

--
-- Table structure for table`view_link_types`
--

CREATE TABLE IF NOT EXISTS `view_link_types`
(
    `view_link_type_id` int(11)      NOT NULL,
    `type_name`         varchar(200) NOT NULL,
    `comment`           text         NOT NULL
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8;

-- --------------------------------------------------------

--
-- Table structure for table`view_type_list`
--

CREATE TABLE IF NOT EXISTS `view_types`
(
    `view_type_id` int(11)      NOT NULL,
    `type_name`    varchar(200) NOT NULL,
    `description`  text         NOT NULL,
    `code_id`      varchar(100) DEFAULT NULL
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8 COMMENT ='to group the masks a link a basic format';

-- --------------------------------------------------------

--
-- Table structure for table`view_term_links`
--

CREATE TABLE IF NOT EXISTS `view_term_links`
(
    `view_term_link_id` int(11) NOT NULL,
    `term_id`           int(11) NOT NULL,
    `type_id`           int(11) NOT NULL DEFAULT '1' COMMENT '1 = from_term_id is link the terms table; 2=link to the term_links table;3=to term_groups',
    `link_type_id`      int(11)          DEFAULT NULL,
    `view_id`           int(11)          DEFAULT NULL,
    `user_id`           int(11) NOT NULL,
    `description`       text             DEFAULT NULL,
    `excluded`          tinyint(4)       DEFAULT NULL,
    `share_type_id`     smallint         DEFAULT NULL,
    `protect_id`        smallint         DEFAULT NULL
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='used to define the default mask for a term or a term group';

-- --------------------------------------------------------

--
-- Table structure for table`user_view_term_links`
--

CREATE TABLE IF NOT EXISTS `user_view_term_links`
(
    `view_term_link_id` int(11) NOT NULL,
    `type_id`           int(11) NOT NULL DEFAULT '1' COMMENT '1 = from_term_id is link the terms table; 2=link to the term_links table;3=to term_groups',
    `link_type_id`      int(11)          DEFAULT NULL,
    `user_id`           int(11) NOT NULL,
    `description`       text             DEFAULT NULL,
    `excluded`          tinyint(4)       DEFAULT NULL,
    `share_type_id`     smallint         DEFAULT NULL,
    `protect_id`        smallint         DEFAULT NULL
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='used to define the default mask for a term or a term group';

-- --------------------------------------------------------

-- --------------------------------------------------------

--
-- Structure for view`phrases`
--
DROP TABLE IF EXISTS `phrases`;

CREATE ALGORITHM = UNDEFINED DEFINER =`root`@`localhost` SQL SECURITY DEFINER VIEW `phrases` AS
select `words`.`word_id`            AS `phrase_id`,
       `words`.`user_id`            AS `user_id`,
       `words`.`word_name`          AS `phrase_name`,
       `words`.`description`        AS `description`,
       `words`.`values`             AS `values`,
       `words`.`phrase_type_id`     AS `phrase_type_id`,
       `words`.`excluded`           AS `excluded`,
       `words`.`share_type_id`      AS `share_type_id`,
       `words`.`protect_id` AS `protect_id`
  from `words`
union
select (`triples`.`triple_id` * -(1)) AS `phrase_id`,
       `triples`.`user_id`               AS `user_id`,
       if(`triples`.`triple_name` is null,
          if(`triples`.`name_given` is null,
             `triples`.`name_generated`,
             `triples`.`name_given`),
          `triples`.`triple_name`) AS `phrase_name`,
       `triples`.`description`           AS `description`,
       `triples`.`values`                AS `values`,
       `triples`.`phrase_type_id`        AS `phrase_type_id`,
       `triples`.`excluded`              AS `excluded`,
       `triples`.`share_type_id`         AS `share_type_id`,
       `triples`.`protect_id`    AS `protect_id`
  from `triples`;

--
-- Structure for view`phrases`
--
DROP TABLE IF EXISTS `user_phrases`;

CREATE ALGORITHM = UNDEFINED DEFINER =`root`@`localhost`SQL
    SECURITY DEFINER VIEW `user_phrases` AS
select `user_words`.`word_id`       AS `phrase_id`,
       `user_words`.`user_id`       AS `user_id`,
       `user_words`.`word_name`     AS `phrase_name`,
       `user_words`.`description`   AS `description`,
       `user_words`.`values`        AS `values`,
       `user_words`.`excluded`      AS `excluded`,
       `user_words`.`share_type_id` AS `share_type_id`,
       `user_words`.`protect_id`    AS `protect_id`
  from `user_words`
union
select (`user_triples`.`triple_id` * -(1)) AS `phrase_id`,
       `user_triples`.`user_id`               AS `user_id`,
       if(`user_triples`.`triple_name` is null,
          if(`user_triples`.`name_given` is null,
             `user_triples`.`name_generated`,
             `user_triples`.`name_given`),
          `user_triples`.`triple_name`) AS `phrase_name`,
       `user_triples`.`description`           AS `description`,
       `user_triples`.`values`                AS `values`,
       `user_triples`.`excluded`              AS `excluded`,
       `user_triples`.`share_type_id`         AS `share_type_id`,
       `user_triples`.`protect_id`            AS `protect_id`
  from `user_triples`;


--
-- Structure for view`terms`
--
DROP TABLE IF EXISTS `terms`;

CREATE ALGORITHM = UNDEFINED DEFINER =`root`@`localhost` SQL SECURITY DEFINER VIEW `terms` AS
select ((`words`.`word_id` * 2) - 1) AS `term_id`,
       `words`.`user_id`           AS `user_id`,
       `words`.`word_name`         AS `term_name`,
       `words`.`description`       AS `description`,
       `words`.`values`            AS `usage`,
       `words`.`phrase_type_id`    AS `term_type_id`,
       `words`.`excluded`          AS `excluded`,
       `words`.`share_type_id`     AS `share_type_id`,
       `words`.`protect_id`        AS `protect_id`,
       ''                          AS `formula_text`,
       ''                          AS `resolved_text`
from `words`
where `words`.`phrase_type_id` <> 10 OR `words`.`phrase_type_id` is null
union
select ((`triples`.`triple_id` * -2) + 1) AS `term_id`,
       `triples`.`user_id`                 AS `user_id`,
       if(`triples`.`triple_name` is null,
          if(`triples`.`name_given` is null,
             `triples`.`name_generated`,
             `triples`.`name_given`),
          `triples`.`triple_name`) AS `phrase_name`,
       `triples`.`description`             AS `description`,
       `triples`.`values`                  AS `usage`,
       `triples`.`phrase_type_id`          AS `term_type_id`,
       `triples`.`excluded`                AS `excluded`,
       `triples`.`share_type_id`           AS `share_type_id`,
       `triples`.`protect_id`              AS `protect_id`,
       ''                                  AS `formula_text`,
       ''                                  AS `resolved_text`
from `triples`
union
select (`formulas`.`formula_id` * 2) AS `term_id`,
       `formulas`.`user_id`         AS `user_id`,
       `formulas`.`formula_name`    AS `term_name`,
       `formulas`.`description`     AS `description`,
       `formulas`.`usage`           AS `usage`,
       `formulas`.`formula_type_id` AS `term_type_id`,
       `formulas`.`excluded`        AS `excluded`,
       `formulas`.`share_type_id`   AS `share_type_id`,
       `formulas`.`protect_id`      AS `protect_id`,
       `formulas`.`formula_text`    AS `formula_text`,
       `formulas`.`resolved_text`   AS `resolved_text`
from `formulas`
union
select (`verbs`.`verb_id` * -2) AS `term_id`,
       NULL                    AS `user_id`,
       `verbs`.`formula_name`  AS `term_name`,
       `verbs`.`description`   AS `description`,
       `verbs`.`words`         AS `usage`,
       NULL                    AS `term_type_id`,
       NULL                    AS `excluded`,
       1                       AS `share_type_id`,
       3                       AS `protect_id`,
       ''                      AS `formula_text`,
       ''                      AS `resolved_text`
from `verbs`
;

--
-- Structure for view `user_terms`
--
DROP TABLE IF EXISTS `user_terms`;

CREATE ALGORITHM = UNDEFINED DEFINER =`root`@`localhost`SQL
    SECURITY DEFINER VIEW `user_terms` AS
select ((`user_words`.`word_id` * 2) - 1) AS `term_id`,
       `user_words`.`user_id`             AS `user_id`,
       `user_words`.`word_name`           AS `term_name`,
       `user_words`.`description`         AS `description`,
       `user_words`.`values`              AS `usage`,
       `user_words`.`excluded`            AS `excluded`,
       `user_words`.`share_type_id`       AS `share_type_id`,
       `user_words`.`protect_id`          AS `protect_id`,
       ''                                 AS `formula_text`,
       ''                                 AS `resolved_text`
from `user_words`
where `user_words`.`phrase_type_id` <> 10
union
select ((`user_triples`.`triple_id` * -2) + 1) AS `term_id`,
       `user_triples`.`user_id`                   AS `user_id`,
       if(`user_triples`.`triple_name` is null,
          if(`user_triples`.`name_given` is null,
             `user_triples`.`name_generated`,
             `user_triples`.`name_given`),
          `user_triples`.`triple_name`) AS `phrase_name`,
       `user_triples`.`description`               AS `description`,
       `user_triples`.`values`                    AS `usage`,
       `user_triples`.`excluded`                  AS `excluded`,
       `user_triples`.`share_type_id`             AS `share_type_id`,
       `user_triples`.`protect_id`                AS `protect_id`,
       ''                                         AS `formula_text`,
       ''                                         AS `resolved_text`
from `user_triples`
union
select (`user_formulas`.`formula_id` * 2) AS `term_id`,
       `user_formulas`.`user_id`          AS `user_id`,
       `user_formulas`.`formula_name`     AS `term_name`,
       `user_formulas`.`description`      AS `description`,
       `user_formulas`.`usage`            AS `usage`,
       `user_formulas`.`excluded`         AS `excluded`,
       `user_formulas`.`share_type_id`    AS `share_type_id`,
       `user_formulas`.`protect_id`       AS `protect_id`,
       `user_formulas`.`formula_text`     AS `formula_text`,
       `user_formulas`.`resolved_text`    AS `resolved_text`
from `user_formulas`
union
select (`verbs`.`verb_id` * -2) AS `term_id`,
       NULL                     AS `user_id`,
       `verbs`.`formula_name`   AS `term_name`,
       `verbs`.`description`    AS `description`,
       `verbs`.`words`          AS `usage`,
       NULL                     AS `excluded`,
       1                        AS `share_type_id`,
       3                        AS `protect_id`,
       ''                       AS `formula_text`,
       ''                       AS `resolved_text`
from `verbs`
;

--
-- Structure for view`change_table_fields`
--
DROP TABLE IF EXISTS `change_table_fields`;

CREATE ALGORITHM = UNDEFINED DEFINER =`root`@`localhost`SQL
    SECURITY DEFINER VIEW `change_table_fields` AS
select `change_fields`.`change_field_id`                                              AS `change_table_field_id`,
       CONCAT(`change_tables`.`change_table_id`, `change_fields`.`change_field_name`) AS `change_table_field_name`,
       `change_fields`.`description`                                                  AS `description`,
       IF(`change_fields`.`code_id` IS NULL,
           CONCAT(`change_tables`.`change_table_id`, `change_fields`.`change_field_name`),
           `change_fields`.`code_id`) AS `code_id`
from `change_fields`,
     `change_tables`
WHERE `change_fields`.table_id = `change_tables`.change_table_id;

--
-- Indexes for dumped tables
--

-- --------------------------------------------------------

--
-- indexes for table config
--

ALTER TABLE config
    ADD PRIMARY KEY (config_id),
    ADD KEY config_config_name_idx (config_name),
    ADD KEY config_code_idx (code_id);

-- --------------------------------------------------------

--
-- indexes for table sys_log_status
--

ALTER TABLE sys_log_status
    ADD PRIMARY KEY (sys_log_status_id),
    ADD KEY sys_log_status_type_name_idx (type_name);

-- --------------------------------------------------------

--
-- indexes for table sys_log_functions
--

ALTER TABLE sys_log_functions
    ADD PRIMARY KEY (sys_log_function_id),
    ADD KEY sys_log_functions_sys_log_function_name_idx (sys_log_function_name);

-- --------------------------------------------------------

--
-- indexes for table sys_log
--

ALTER TABLE sys_log
    ADD PRIMARY KEY (sys_log_id),
    ADD KEY sys_log_sys_log_time_idx (sys_log_time),
    ADD KEY sys_log_sys_log_type_idx (sys_log_type_id),
    ADD KEY sys_log_sys_log_function_idx (sys_log_function_id),
    ADD KEY sys_log_user_idx (user_id),
    ADD KEY sys_log_solver_idx (solver_id),
    ADD KEY sys_log_sys_log_status_idx (sys_log_status_id);

--
-- Indexes for table`calc_and_cleanup_tasks`
--
ALTER TABLE `calc_and_cleanup_tasks`
    ADD PRIMARY KEY (`calc_and_cleanup_task_id`);

--
-- Indexes for table`calc_and_cleanup_task_types`
--
ALTER TABLE `calc_and_cleanup_task_types`
    ADD PRIMARY KEY (`calc_and_cleanup_task_type_id`);

--
-- Indexes for table`changes`
--
ALTER TABLE `changes`
    ADD PRIMARY KEY (`change_id`),
    ADD KEY `table_id` (`change_field_id`, `row_id`),
    ADD KEY `change_action_id` (`change_action_id`);

--
-- Indexes for table`change_actions`
--
ALTER TABLE `change_actions`
    ADD PRIMARY KEY (`change_action_id`);

--
-- Indexes for table`change_fields`
--
ALTER TABLE `change_fields`
    ADD PRIMARY KEY (`change_field_id`),
    ADD KEY `table_id` (`table_id`);

--
-- Indexes for table`change_links`
--
ALTER TABLE `change_links`
    ADD PRIMARY KEY (`change_link_id`),
    ADD KEY `user` (`user_id`),
    ADD KEY `change_table_id` (`change_table_id`),
    ADD KEY `change_action_id` (`change_action_id`);

--
-- Indexes for table`change_tables`
--
ALTER TABLE `change_tables`
    ADD PRIMARY KEY (`change_table_id`);

--
-- Indexes for table`comments`
--
ALTER TABLE `comments`
    ADD PRIMARY KEY (`comment_id`);

-- --------------------------------------------------------

--
-- indexes for table words
--
ALTER TABLE words
    ADD PRIMARY KEY (word_id),
    ADD KEY words_user_idx (user_id),
    ADD KEY words_word_name_idx (word_name),
    ADD KEY words_plural_idx (plural),
    ADD KEY words_phrase_type_idx (phrase_type_id),
    ADD KEY words_view_idx (view_id);

--
-- indexes for table user_words
--
ALTER TABLE user_words
    ADD PRIMARY KEY (word_id, user_id, language_id),
    ADD KEY user_words_word_idx (word_id),
    ADD KEY user_words_user_idx (user_id),
    ADD KEY user_words_language_idx (language_id),
    ADD KEY user_words_word_name_idx (word_name),
    ADD KEY user_words_plural_idx (plural),
    ADD KEY user_words_phrase_type_idx (phrase_type_id),
    ADD KEY user_words_view_idx (view_id);

-- --------------------------------------------------------

--
-- indexes for table triples
--

ALTER TABLE triples
    ADD PRIMARY KEY (triple_id),
    ADD UNIQUE KEY triples_unique_idx  (from_phrase_id, verb_id, to_phrase_id),
    ADD KEY triples_user_idx           (user_id),
    ADD KEY triples_from_phrase_idx    (from_phrase_id),
    ADD KEY triples_verb_idx           (verb_id),
    ADD KEY triples_to_phrase_idx      (to_phrase_id),
    ADD KEY triples_triple_name_idx    (triple_name),
    ADD KEY triples_name_given_idx     (name_given),
    ADD KEY triples_name_generated_idx (name_generated),
    ADD KEY triples_phrase_type_idx    (phrase_type_id),
    ADD KEY triples_view_idx           (view_id);

--
-- indexes for table user_triples
--

ALTER TABLE user_triples ADD PRIMARY KEY (triple_id, user_id, language_id),
     ADD KEY user_triples_triple_idx         (triple_id),
     ADD KEY user_triples_user_idx           (user_id),
     ADD KEY user_triples_language_idx       (language_id),
     ADD KEY user_triples_triple_name_idx    (triple_name),
     ADD KEY user_triples_name_given_idx     (name_given),
     ADD KEY user_triples_name_generated_idx (name_generated),
     ADD KEY user_triples_phrase_type_idx    (phrase_type_id),
     ADD KEY user_triples_view_idx           (view_id);

-- --------------------------------------------------------

--
-- indexes for table groups
--
ALTER TABLE `groups`
    ADD PRIMARY KEY (group_id),
    ADD KEY groups_user_idx (user_id);

--
-- indexes for table user_groups
--
ALTER TABLE user_groups
    ADD PRIMARY KEY (group_id, user_id),
    ADD KEY user_groups_user_idx (user_id);

--
-- indexes for table groups_prime
--
ALTER TABLE groups_prime
    ADD PRIMARY KEY (group_id),
    ADD KEY groups_prime_user_idx (user_id);

--
-- indexes for table user_groups_prime
--
ALTER TABLE user_groups_prime
    ADD PRIMARY KEY (group_id, user_id),
    ADD KEY user_groups_prime_user_idx (user_id);

--
-- indexes for table groups_big
--
ALTER TABLE groups_big
    ADD PRIMARY KEY (group_id),
    ADD KEY groups_big_user_idx (user_id);

--
-- indexes for table user_groups_big
--
ALTER TABLE user_groups_big
    ADD PRIMARY KEY (group_id, user_id),
    ADD KEY user_groups_big_user_idx (user_id);

--
-- Indexes for table`formulas`
--
ALTER TABLE `formulas`
    ADD PRIMARY KEY (`formula_id`),
    ADD UNIQUE KEY `name` (`formula_name`),
    ADD KEY `user_id` (`user_id`),
    ADD KEY `formula_type_id` (`formula_type_id`),
    ADD KEY `protect_id` (`protect_id`);

--
-- Indexes for table`formula_elements`
--
ALTER TABLE `formula_elements`
    ADD PRIMARY KEY (`formula_element_id`),
    ADD KEY `formula_id` (`formula_id`),
    ADD KEY `formula_element_type_id` (`formula_element_type_id`);

--
-- Indexes for table`formula_links`
--
ALTER TABLE `formula_links`
    ADD PRIMARY KEY (`formula_link_id`),
    ADD KEY `user_id` (`user_id`),
    ADD KEY `formula_id` (`formula_id`),
    ADD KEY `link_type_id` (`link_type_id`);

--
-- Indexes for table`formula_link_types`
--
ALTER TABLE `formula_link_types`
    ADD PRIMARY KEY (`formula_link_type_id`);

-- --------------------------------------------------------

--
-- indexes for table formula_types
--

ALTER TABLE formula_types
    ADD PRIMARY KEY (formula_type_id),
    ADD KEY formula_types_type_name_idx (type_name);

--
-- Indexes for table`results`
--
ALTER TABLE `results`
    ADD PRIMARY KEY (`group_id`),
    ADD UNIQUE KEY `formula_id_2` (`formula_id`, `user_id`, `phrase_group_id`,
                                   `source_phrase_group_id`),
    ADD KEY `user_id` (`user_id`);

--
-- Indexes for table`import_source`
--
ALTER TABLE `import_source`
    ADD PRIMARY KEY (`import_source_id`);

--
-- Indexes for table`languages`
--
ALTER TABLE `languages`
    ADD PRIMARY KEY (`language_id`);

--
-- Indexes for table`language_forms`
--
ALTER TABLE `language_forms`
    ADD PRIMARY KEY (`language_form_id`);

--
-- Indexes for table`phrase_groups`
--
ALTER TABLE `groups`
    ADD PRIMARY KEY (group_id),
    ADD UNIQUE KEY `term_ids` (`word_ids`, `triple_ids`);

--
-- Indexes for table`phrase_group_word_links`
--
ALTER TABLE group_links
    ADD PRIMARY KEY (`phrase_group_word_link_id`),
    ADD KEY `phrase_group_id` (`phrase_group_id`),
    ADD KEY `word_id` (`word_id`);

--
-- Indexes for table`phrase_group_triple_links`
--
ALTER TABLE `phrase_group_triple_links`
    ADD PRIMARY KEY (`phrase_group_triple_link_id`),
    ADD KEY `phrase_group_id` (`phrase_group_id`),
    ADD KEY `triple_id` (`triple_id`);

--
-- Indexes for table`protection_types`
--
ALTER TABLE `protection_types`
    ADD PRIMARY KEY (`protect_id`),
    ADD UNIQUE KEY `protection_type_id` (`protect_id`);

--
-- Indexes for table`refs`
--
ALTER TABLE `refs`
    ADD PRIMARY KEY (`ref_id`),
    ADD UNIQUE KEY `phrase_id` (`phrase_id`, `ref_type_id`),
    ADD UNIQUE KEY `phrase_id_2` (`phrase_id`, `ref_type_id`),
    ADD KEY `ref_type_id` (`ref_type_id`);

--
-- Indexes for table`ref_types`
--
ALTER TABLE `ref_types`
    ADD PRIMARY KEY (`ref_type_id`),
    ADD UNIQUE KEY `ref_type_name` (`type_name`, `code_id`);

--
-- Indexes for table`sessions`
--
ALTER TABLE `sessions`
    ADD PRIMARY KEY (`id`);

--
-- Indexes for table`share_types`
--
ALTER TABLE `share_types`
    ADD PRIMARY KEY (`share_type_id`);

-- --------------------------------------------------------

--
-- indexes for table sources
--
ALTER TABLE sources
    ADD PRIMARY KEY (source_id),
    ADD KEY sources_user_idx (user_id),
    ADD KEY sources_source_name_idx (source_name),
    ADD KEY sources_source_type_idx (source_type_id);

--
-- indexes for table user_sources
--
ALTER TABLE user_sources
    ADD PRIMARY KEY (source_id, user_id),
    ADD KEY user_sources_source_idx (source_id),
    ADD KEY user_sources_user_idx (user_id),
    ADD KEY user_sources_source_name_idx (source_name),
    ADD KEY user_sources_source_type_idx (source_type_id);

-- --------------------------------------------------------

--
-- indexes for table source_types
--

ALTER TABLE source_types
    ADD PRIMARY KEY (source_type_id),
    ADD KEY source_types_type_name_idx (type_name);


--
-- Indexes for table`source_values`
--
ALTER TABLE `source_values`
    ADD PRIMARY KEY (`group_id`, `source_id`, `user_id`),
    ADD KEY `group_id` (`group_id`),
    ADD KEY `source_id` (`source_id`),
    ADD KEY `user_id` (`user_id`);

--
-- Indexes for table`sys_log`
--
ALTER TABLE `sys_log`
    ADD PRIMARY KEY (`sys_log_id`),
    ADD KEY `sys_log_time` (`sys_log_time`),
    ADD KEY `sys_log_type_id` (`sys_log_type_id`),
    ADD KEY `sys_log_function_id` (`sys_log_function_id`),
    ADD KEY `sys_log_status_id` (`sys_log_status_id`);

--
-- Indexes for table`sys_log_functions`
--
ALTER TABLE `sys_log_functions`
    ADD PRIMARY KEY (`sys_log_function_id`);

--
-- Indexes for table`sys_log_status`
--
ALTER TABLE `sys_log_status`
    ADD PRIMARY KEY (`sys_log_status_id`);

--
-- Indexes for table`sys_log_types`
--
ALTER TABLE `sys_log_types`
    ADD PRIMARY KEY (`sys_log_type_id`);

--
-- Indexes for table`sys_scripts`
--
ALTER TABLE `sys_scripts`
    ADD PRIMARY KEY (`sys_script_id`);

--
-- Indexes for table`sys_script_times`
--
ALTER TABLE `sys_script_times`
    ADD KEY `sys_script_id` (`sys_script_id`);

--
-- Indexes for table`users`
--
ALTER TABLE `users`
    ADD PRIMARY KEY (`user_id`),
    ADD UNIQUE KEY `user_name` (`user_name`),
    ADD KEY `user_type_id` (`user_type_id`);

--
-- Indexes for table`user_attempts`
--
ALTER TABLE `user_attempts`
    ADD PRIMARY KEY (`id`);

--
-- Indexes for table`user_blocked_ips`
--
ALTER TABLE `user_blocked_ips`
    ADD PRIMARY KEY (`user_blocked_id`);

-- --------------------------------------------------------
--
-- indexes for table formulas
--

ALTER TABLE formulas
    ADD PRIMARY KEY (formula_id),
    ADD KEY formulas_user_idx (user_id),
    ADD KEY formulas_formula_name_idx (formula_name),
    ADD KEY formulas_formula_type_idx (formula_type_id),
    ADD KEY formulas_view_idx (view_id);

--
-- indexes for table user_formulas
--

ALTER TABLE user_formulas
    ADD PRIMARY KEY (formula_id,user_id),
    ADD KEY user_formulas_formula_idx (formula_id),
    ADD KEY user_formulas_user_idx (user_id),
    ADD KEY user_formulas_formula_name_idx (formula_name),
    ADD KEY user_formulas_formula_type_idx (formula_type_id),
    ADD KEY user_formulas_view_idx (view_id);

--
-- Indexes for table`user_formula_links`
--
ALTER TABLE `user_formula_links`
    ADD UNIQUE KEY `formula_link_id` (`formula_link_id`, `user_id`),
    ADD KEY `formula_link_id_2` (`formula_link_id`),
    ADD KEY `user_id` (`user_id`),
    ADD KEY `link_type_id` (`link_type_id`);

--
-- Indexes for table`user_official_types`
--
ALTER TABLE `user_official_types`
    ADD PRIMARY KEY (`user_official_type_id`);

--
-- Indexes for table`user_phrase_groups`
--
ALTER TABLE user_groups
    ADD UNIQUE KEY `phrase_group_id` (group_id, `user_id`),
    ADD KEY `phrase_group_id_2` (group_id),
    ADD KEY `user_id` (`user_id`);

--
-- Indexes for table`user_phrase_group_word_links`
--
ALTER TABLE user_group_links
    ADD UNIQUE KEY `phrase_group_word_link_id` (`phrase_group_word_link_id`, `user_id`),
    ADD KEY `phrase_group_word_link_id_2` (`phrase_group_word_link_id`),
    ADD KEY `user_id` (`user_id`);

--
-- Indexes for table`user_phrase_group_triple_links`
--
ALTER TABLE `user_phrase_group_triple_links`
    ADD UNIQUE KEY `phrase_group_triple_link_id` (`phrase_group_triple_link_id`, `user_id`),
    ADD KEY `phrase_group_triple_link_id_2` (`phrase_group_triple_link_id`),
    ADD KEY `user_id` (`user_id`);

-- --------------------------------------------------------

--
-- indexes for table user_profiles
--

ALTER TABLE user_profiles
    ADD PRIMARY KEY (user_profile_id),
    ADD KEY user_profiles_type_name_idx (type_name);

--
-- Indexes for table`user_requests`
--
ALTER TABLE `user_requests`
    ADD PRIMARY KEY (`id`);

--
-- Indexes for table`user_sources`
--
ALTER TABLE `user_sources`
    ADD UNIQUE KEY `source_id` (`source_id`, `user_id`),
    ADD KEY `user_id` (`user_id`),
    ADD KEY `source_id_2` (`source_id`),
    ADD KEY `source_type_id` (`source_type_id`);

--
-- Indexes for table`user_refs`
--
ALTER TABLE `user_refs`
    ADD UNIQUE KEY `ref_id` (`ref_id`, `user_id`),
    ADD KEY `user_id` (`user_id`),
    ADD KEY `ref_id_2` (`ref_id`);

--
-- Indexes for table`user_types`
--
ALTER TABLE `user_types`
    ADD PRIMARY KEY (`user_type_id`);

--
-- Indexes for table`user_values`
--
ALTER TABLE `user_values`
    ADD PRIMARY KEY (`group_id`, `user_id`),
    ADD KEY `user_id` (`user_id`),
    ADD KEY `source_id` (`source_id`),
    ADD KEY `group_id` (`group_id`),
    ADD KEY `share_type` (`share_type_id`),
    ADD KEY `protect_id` (`protect_id`);

--
-- Indexes for table`user_value_time_series`
--
ALTER TABLE `user_value_time_series`
    ADD PRIMARY KEY (`value_time_series_id`, `user_id`),
    ADD KEY `user_id` (`user_id`),
    ADD KEY `source_id` (`source_id`),
    ADD KEY `group_id` (`value_time_series_id`),
    ADD KEY `share_type` (`share_type_id`),
    ADD KEY `protect_id` (`protect_id`);

-- --------------------------------------------------------

--
-- indexes for table views
--

ALTER TABLE views
    ADD PRIMARY KEY (view_id),
    ADD KEY views_user_idx (user_id),
    ADD KEY views_view_name_idx (view_name),
    ADD KEY views_view_type_idx (view_type_id);

--
-- indexes for table user_views
--

ALTER TABLE user_views
    ADD PRIMARY KEY (view_id,user_id,language_id),
    ADD KEY user_views_view_idx (view_id),
    ADD KEY user_views_user_idx (user_id),
    ADD KEY user_views_language_idx (language_id),
    ADD KEY user_views_view_name_idx (view_name),
    ADD KEY user_views_view_type_idx (view_type_id);

-- --------------------------------------------------------

--
-- indexes for table components
--

ALTER TABLE components
    ADD PRIMARY KEY (component_id),
    ADD KEY components_user_idx (user_id),
    ADD KEY components_component_name_idx (component_name),
    ADD KEY components_component_type_idx (component_type_id),
    ADD KEY components_word_id_row_idx (word_id_row),
    ADD KEY components_formula_idx (formula_id),
    ADD KEY components_word_id_col_idx (word_id_col),
    ADD KEY components_word_id_col2_idx (word_id_col2),
    ADD KEY components_linked_component_idx (linked_component_id),
    ADD KEY components_component_link_type_idx (component_link_type_id),
    ADD KEY components_link_type_idx (link_type_id);

--
-- indexes for table user_components
--

ALTER TABLE user_components
    ADD PRIMARY KEY (component_id,user_id),
    ADD KEY user_components_component_idx (component_id),
    ADD KEY user_components_user_idx (user_id),
    ADD KEY user_components_component_name_idx (component_name),
    ADD KEY user_components_component_type_idx (component_type_id),
    ADD KEY user_components_word_id_row_idx (word_id_row),
    ADD KEY user_components_formula_idx (formula_id),
    ADD KEY user_components_word_id_col_idx (word_id_col),
    ADD KEY user_components_word_id_col2_idx (word_id_col2),
    ADD KEY user_components_linked_component_idx (linked_component_id),
    ADD KEY user_components_component_link_type_idx (component_link_type_id),
    ADD KEY user_components_link_type_idx (link_type_id);
--
-- Indexes for table`user_component_links`
--
ALTER TABLE `user_component_links`
    ADD PRIMARY KEY (`component_link_id`, `user_id`),
    ADD KEY `user_id` (`user_id`),
    ADD KEY `position_type` (`position_type`),
    ADD KEY `component_link_id` (`component_link_id`);

--
-- Indexes for table`user_words`
--
ALTER TABLE `user_words`
    ADD PRIMARY KEY (`word_id`, `user_id`, `language_id`),
    ADD KEY `word_id` (`word_id`),
    ADD KEY `user_id` (`user_id`),
    ADD KEY `language_id` (`language_id`),
    ADD KEY `phrase_type_id` (`phrase_type_id`),
    ADD KEY `view_id` (`view_id`);

--
-- Indexes for table`user_triples`
--
ALTER TABLE `user_triples`
    ADD UNIQUE KEY `triple_id` (`triple_id`, `user_id`),
    ADD KEY `triple_id_2` (`triple_id`),
    ADD KEY `user_id` (`user_id`);

--
-- Indexes for table`values`
--
ALTER TABLE `values`
    ADD PRIMARY KEY (`group_id`),
    ADD KEY `user_id` (`user_id`),
    ADD KEY `source_id` (`source_id`),
    ADD KEY `phrase_group_id` (`phrase_group_id`),
    ADD KEY `protect_id` (`protect_id`);

--
-- Indexes for table`value_formula_links`
--
ALTER TABLE `value_formula_links`
    ADD PRIMARY KEY (`value_formula_link_id`);

--
-- Indexes for table`value_phrase_links`
--
ALTER TABLE `value_phrase_links`
    ADD PRIMARY KEY (`value_phrase_link_id`),
    ADD UNIQUE KEY `user_id` (`user_id`, `group_id`, `phrase_id`),
    ADD KEY `group_id` (`group_id`),
    ADD KEY `phrase_id` (`phrase_id`);

--
-- Indexes for table`value_relations`
--
ALTER TABLE `value_relations`
    ADD PRIMARY KEY (`value_link_id`);

--
-- Indexes for table`value_time_series`
--
ALTER TABLE `value_time_series`
    ADD PRIMARY KEY (`value_time_series_id`);

--
-- Indexes for table`value_ts_data`
--
ALTER TABLE `value_ts_data`
    ADD KEY `value_time_series_id` (`value_time_series_id`, `val_time`);

--
-- Indexes for table`verbs`
--
ALTER TABLE `verbs`
    ADD PRIMARY KEY (`verb_id`);

--
-- Indexes for table`verb_usages`
--
ALTER TABLE `verb_usages`
    ADD PRIMARY KEY (`verb_usage_id`);

--
-- Indexes for table`views`
--
ALTER TABLE `views`
    ADD PRIMARY KEY (`view_id`),
    ADD KEY `view_type_id` (`view_type_id`);

--
-- Indexes for table`components`
--
ALTER TABLE `components`
    ADD PRIMARY KEY (`component_id`),
    ADD KEY `formula_id` (`formula_id`);

--
-- Indexes for table`component_links`
--
ALTER TABLE `component_links`
    ADD PRIMARY KEY (`component_link_id`),
    ADD KEY `view_id` (`view_id`),
    ADD KEY `component_id` (`component_id`),
    ADD KEY `view_position_type_id` (`position_type`);

--
-- Indexes for table`component_link_types`
--
ALTER TABLE `component_link_types`
    ADD PRIMARY KEY (`component_link_type_id`);

--
-- Indexes for table`component_position_types`
--
ALTER TABLE `component_position_types`
    ADD PRIMARY KEY (`component_position_type_id`);

--
-- Indexes for table`component_types`
--
ALTER TABLE `component_types`
    ADD PRIMARY KEY (`component_type_id`);

--
-- Indexes for table`view_link_types`
--
ALTER TABLE `view_link_types`
    ADD PRIMARY KEY (`view_link_type_id`);

--
-- Indexes for table`view_type_list`
--
ALTER TABLE `view_types`
    ADD PRIMARY KEY (`view_type_id`);

--
-- Indexes for table`view_term_links`
--
ALTER TABLE `view_term_links`
    ADD PRIMARY KEY (`view_term_link_id`);

--
-- Indexes for table`words`
--
ALTER TABLE `words`
    ADD PRIMARY KEY (`word_id`),
    ADD UNIQUE KEY `word_name` (`word_name`),
    ADD KEY `phrase_type_id` (`phrase_type_id`),
    ADD KEY `view_id` (`view_id`);

--
-- Indexes for table`word_del_requests`
--
ALTER TABLE `word_del_requests`
    ADD PRIMARY KEY (`word_del_request_id`);

--
-- Indexes for table`triples`
--
ALTER TABLE `triples`
    ADD PRIMARY KEY (`triple_id`);

--
-- Indexes for table`word_periods`
--
ALTER TABLE `word_periods`
    ADD PRIMARY KEY (`word_id`);

-- --------------------------------------------------------

--
-- indexes for table user_types
--

ALTER TABLE user_types
    ADD PRIMARY KEY (user_type_id),
    ADD KEY user_types_type_name_idx (type_name);

-- --------------------------------------------------------

--
-- indexes for table protection_types
--

ALTER TABLE protection_types
    ADD PRIMARY KEY (protection_type_id),
    ADD KEY protection_types_type_name_idx (type_name);

-- --------------------------------------------------------

--
-- indexes for table share_types
--

ALTER TABLE share_types
    ADD PRIMARY KEY (share_type_id),
    ADD KEY share_types_type_name_idx (type_name);

-- --------------------------------------------------------

--
-- indexes for table phrase_types
--

ALTER TABLE phrase_types
    ADD PRIMARY KEY (phrase_type_id),
    ADD KEY phrase_types_type_name_idx (type_name);

--
-- Constraints for dumped tables
--

--
-- AUTO_INCREMENT for exported tables
--

--
-- AUTO_INCREMENT for table`calc_and_cleanup_tasks`
--
ALTER TABLE `calc_and_cleanup_tasks`
    MODIFY `calc_and_cleanup_task_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`calc_and_cleanup_task_types`
--
ALTER TABLE `calc_and_cleanup_task_types`
    MODIFY `calc_and_cleanup_task_type_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`changes`
--
ALTER TABLE `changes`
    MODIFY `change_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`change_actions`
--
ALTER TABLE `change_actions`
    MODIFY `change_action_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`change_fields`
--
ALTER TABLE `change_fields`
    MODIFY `change_field_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`change_links`
--
ALTER TABLE `change_links`
    MODIFY `change_link_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`change_tables`
--
ALTER TABLE `change_tables`
    MODIFY `change_table_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`comments`
--
ALTER TABLE `comments`
    MODIFY `comment_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`formulas`
--
ALTER TABLE `formulas`
    MODIFY `formula_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`formula_elements`
--
ALTER TABLE `formula_elements`
    MODIFY `formula_element_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`formula_links`
--
ALTER TABLE `formula_links`
    MODIFY `formula_link_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`formula_link_types`
--
ALTER TABLE `formula_link_types`
    MODIFY `formula_link_type_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`formula_types`
--
ALTER TABLE `formula_types`
    MODIFY `formula_type_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`results`
--
ALTER TABLE `results`
    MODIFY `group_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`import_source`
--
ALTER TABLE `import_source`
    MODIFY `import_source_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`languages`
--
ALTER TABLE `languages`
    MODIFY `language_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`language_forms`
--
ALTER TABLE `language_forms`
    MODIFY `language_form_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`phrase_groups`
--
ALTER TABLE `groups`
    MODIFY group_id int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`phrase_group_word_links`
--
ALTER TABLE group_links
    MODIFY `phrase_group_word_link_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`phrase_group_triple_links`
--
ALTER TABLE `phrase_group_triple_links`
    MODIFY `phrase_group_triple_link_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`protection_types`
--
ALTER TABLE `protection_types`
    MODIFY `protect_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`refs`
--
ALTER TABLE `refs`
    MODIFY `ref_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`ref_types`
--
ALTER TABLE `ref_types`
    MODIFY `ref_type_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`sessions`
--
ALTER TABLE `sessions`
    MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`share_types`
--
ALTER TABLE `share_types`
    MODIFY `share_type_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`sources`
--
ALTER TABLE `sources`
    MODIFY `source_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`source_types`
--
ALTER TABLE `source_types`
    MODIFY `source_type_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`sys_log`
--
ALTER TABLE `sys_log`
    MODIFY `sys_log_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`sys_log_functions`
--
ALTER TABLE `sys_log_functions`
    MODIFY `sys_log_function_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`sys_log_status`
--
ALTER TABLE `sys_log_status`
    MODIFY `sys_log_status_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`sys_log_types`
--
ALTER TABLE `sys_log_types`
    MODIFY `sys_log_type_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`sys_scripts`
--
ALTER TABLE `sys_scripts`
    MODIFY `sys_script_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`users`
--
ALTER TABLE `users`
    MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`user_attempts`
--
ALTER TABLE `user_attempts`
    MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`user_blocked_ips`
--
ALTER TABLE `user_blocked_ips`
    MODIFY `user_blocked_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`user_official_types`
--
ALTER TABLE `user_official_types`
    MODIFY `user_official_type_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`user_profiles`
--
ALTER TABLE `user_profiles`
    MODIFY `profile_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`user_requests`
--
ALTER TABLE `user_requests`
    MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`user_types`
--
ALTER TABLE `user_types`
    MODIFY `user_type_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`values`
--
ALTER TABLE `values`
    MODIFY `group_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`value_formula_links`
--
ALTER TABLE `value_formula_links`
    MODIFY `value_formula_link_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`value_phrase_links`
--
ALTER TABLE `value_phrase_links`
    MODIFY `value_phrase_link_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`value_relations`
--
ALTER TABLE `value_relations`
    MODIFY `value_link_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`value_time_series`
--
ALTER TABLE `value_time_series`
    MODIFY `value_time_series_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`verbs`
--
ALTER TABLE `verbs`
    MODIFY `verb_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`verb_usages`
--
ALTER TABLE `verb_usages`
    MODIFY `verb_usage_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`views`
--
ALTER TABLE `views`
    MODIFY `view_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`components`
--
ALTER TABLE `components`
    MODIFY `component_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`component_links`
--
ALTER TABLE `component_links`
    MODIFY `component_link_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`component_link_types`
--
ALTER TABLE `component_link_types`
    MODIFY `component_link_type_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`component_position_types`
--
ALTER TABLE `component_position_types`
    MODIFY `component_position_type_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`component_types`
--
ALTER TABLE `component_types`
    MODIFY `component_type_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`view_link_types`
--
ALTER TABLE `view_link_types`
    MODIFY `view_link_type_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`view_type_list`
--
ALTER TABLE `view_types`
    MODIFY `view_type_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`view_term_links`
--
ALTER TABLE `view_term_links`
    MODIFY `view_term_link_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`words`
--
ALTER TABLE `words`
    MODIFY `word_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`word_del_requests`
--
ALTER TABLE `word_del_requests`
    MODIFY `word_del_request_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`triples`
--
ALTER TABLE `triples`
    MODIFY `triple_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table`phrase_types`
--
ALTER TABLE `phrase_types`
    MODIFY `phrase_type_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- constraints for table sys_log
--

ALTER TABLE sys_log
    ADD CONSTRAINT sys_log_sys_log_function_fk FOREIGN KEY (sys_log_function_id) REFERENCES sys_log_functions (sys_log_function_id),
    ADD CONSTRAINT sys_log_user_fk FOREIGN KEY (user_id) REFERENCES users (user_id),
    ADD CONSTRAINT sys_log_user2_fk FOREIGN KEY (solver_id) REFERENCES users (user_id),
    ADD CONSTRAINT sys_log_sys_log_status_fk FOREIGN KEY (sys_log_status_id) REFERENCES sys_log_status (sys_log_status_id);

--
-- Constraints for table`changes`
--
ALTER TABLE `changes`
    ADD CONSTRAINT `changes_fk_1` FOREIGN KEY (`change_field_id`) REFERENCES `change_fields` (`change_field_id`),
    ADD CONSTRAINT `changes_fk_2` FOREIGN KEY (`change_action_id`) REFERENCES `change_actions` (`change_action_id`);

--
-- Constraints for table`change_fields`
--
ALTER TABLE `change_fields`
    ADD CONSTRAINT `change_fields_fk_1` FOREIGN KEY (`table_id`) REFERENCES `change_tables` (`change_table_id`);

--
-- Constraints for table`change_links`
--
ALTER TABLE `change_links`
    ADD CONSTRAINT `change_links_fk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON
        DELETE NO ACTION,
    ADD CONSTRAINT `change_links_fk_2` FOREIGN KEY (`change_table_id`) REFERENCES `change_tables` (`change_table_id`),
    ADD CONSTRAINT `change_links_fk_3` FOREIGN KEY (`change_action_id`) REFERENCES `change_actions` (`change_action_id`);

-- --------------------------------------------------------

--
-- constraints for table words
--
ALTER TABLE words
    ADD CONSTRAINT word_name_uk UNIQUE (word_name),
    ADD CONSTRAINT code_id_uk UNIQUE (code_id),
    ADD CONSTRAINT words_user_fk FOREIGN KEY (user_id) REFERENCES users (user_id),
    ADD CONSTRAINT words_phrase_type_fk FOREIGN KEY (phrase_type_id) REFERENCES phrase_types (phrase_type_id),
    ADD CONSTRAINT words_view_fk FOREIGN KEY (view_id) REFERENCES views (view_id);

--
-- constraints for table user_words
--
ALTER TABLE user_words
    ADD CONSTRAINT user_words_word_fk FOREIGN KEY (word_id) REFERENCES words (word_id),
    ADD CONSTRAINT user_words_user_fk FOREIGN KEY (user_id) REFERENCES users (user_id),
    ADD CONSTRAINT user_words_language_fk FOREIGN KEY (language_id) REFERENCES languages (language_id),
    ADD CONSTRAINT user_words_phrase_type_fk FOREIGN KEY (phrase_type_id) REFERENCES phrase_types (phrase_type_id),
    ADD CONSTRAINT user_words_view_fk FOREIGN KEY (view_id) REFERENCES views (view_id);

-- --------------------------------------------------------

--
-- constraints for table triples
--
ALTER TABLE triples
    ADD CONSTRAINT code_id_uk UNIQUE (code_id),
    ADD CONSTRAINT triples_user_fk        FOREIGN KEY (user_id)        REFERENCES users (user_id),
    ADD CONSTRAINT triples_verb_fk        FOREIGN KEY (verb_id)        REFERENCES verbs (verb_id),
    ADD CONSTRAINT triples_phrase_type_fk FOREIGN KEY (phrase_type_id) REFERENCES phrase_types (phrase_type_id),
    ADD CONSTRAINT triples_view_fk        FOREIGN KEY (view_id)        REFERENCES views (view_id);

--
-- constraints for table user_triples
--
ALTER TABLE user_triples
    ADD CONSTRAINT user_triples_triple_fk      FOREIGN KEY (triple_id)      REFERENCES triples (triple_id),
    ADD CONSTRAINT user_triples_user_fk        FOREIGN KEY (user_id)        REFERENCES users (user_id),
    ADD CONSTRAINT user_triples_language_fk    FOREIGN KEY (language_id)    REFERENCES languages (language_id),
    ADD CONSTRAINT user_triples_phrase_type_fk FOREIGN KEY (phrase_type_id) REFERENCES phrase_types (phrase_type_id),
    ADD CONSTRAINT user_triples_view_fk        FOREIGN KEY (view_id)        REFERENCES views (view_id);

-- --------------------------------------------------------

--
-- constraints for table formulas
--
ALTER TABLE formulas
    ADD CONSTRAINT formula_name_uk UNIQUE (formula_name),
    ADD CONSTRAINT formulas_user_fk FOREIGN KEY (user_id) REFERENCES users (user_id),
    ADD CONSTRAINT formulas_formula_type_fk FOREIGN KEY (formula_type_id) REFERENCES formula_types (formula_type_id),
    ADD CONSTRAINT formulas_view_fk FOREIGN KEY (view_id) REFERENCES views (view_id);

--
-- constraints for table user_formulas
--
ALTER TABLE user_formulas
    ADD CONSTRAINT user_formulas_formula_fk FOREIGN KEY (formula_id) REFERENCES formulas (formula_id),
    ADD CONSTRAINT user_formulas_user_fk FOREIGN KEY (user_id) REFERENCES users (user_id),
    ADD CONSTRAINT user_formulas_formula_type_fk FOREIGN KEY (formula_type_id) REFERENCES formula_types (formula_type_id),
    ADD CONSTRAINT user_formulas_view_fk FOREIGN KEY (view_id) REFERENCES views (view_id);

--
-- Constraints for table`formula_links`
--
ALTER TABLE `formula_links`
    ADD CONSTRAINT `formula_links_fk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table`results`
--
ALTER TABLE `results`
    ADD CONSTRAINT `results_fk_1` FOREIGN KEY (`formula_id`) REFERENCES `formulas` (`formula_id`),
    ADD CONSTRAINT `results_fk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

-- --------------------------------------------------------

--
-- constraints for table groups
--
ALTER TABLE `groups`
    ADD CONSTRAINT groups_user_fk FOREIGN KEY (user_id) REFERENCES users (user_id);

--
-- constraints for table user_groups
--
ALTER TABLE user_groups
    ADD CONSTRAINT user_groups_user_fk FOREIGN KEY (user_id) REFERENCES users (user_id);

--
-- constraints for table groups_prime
--
ALTER TABLE groups_prime
    ADD CONSTRAINT groups_prime_user_fk FOREIGN KEY (user_id) REFERENCES users (user_id);

--
-- constraints for table user_groups_prime
--
ALTER TABLE user_groups_prime
    ADD CONSTRAINT user_groups_prime_user_fk FOREIGN KEY (user_id) REFERENCES users (user_id);

--
-- constraints for table groups_big
--
ALTER TABLE groups_big
    ADD CONSTRAINT groups_big_user_fk FOREIGN KEY (user_id) REFERENCES users (user_id);

--
-- constraints for table user_groups_big
--
ALTER TABLE user_groups_big
    ADD CONSTRAINT user_groups_big_user_fk FOREIGN KEY (user_id) REFERENCES users (user_id);

--
-- Constraints for table`refs`
--
ALTER TABLE `refs`
    ADD CONSTRAINT `refs_fk_1` FOREIGN KEY (`ref_type_id`) REFERENCES `ref_types` (`ref_type_id`);

--
-- Constraints for table`source_values`
--
ALTER TABLE `source_values`
    ADD CONSTRAINT `source_values_fk_3` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
    ADD CONSTRAINT `source_values_fk_1` FOREIGN KEY (`group_id`) REFERENCES `values` (`group_id`),
    ADD CONSTRAINT `source_values_fk_2` FOREIGN KEY (`source_id`) REFERENCES `sources` (`source_id`);

--
-- Constraints for table`sys_log`
--
ALTER TABLE `sys_log`
    ADD CONSTRAINT `sys_log_fk_1` FOREIGN KEY (`sys_log_status_id`) REFERENCES `sys_log_status` (`sys_log_status_id`),
    ADD CONSTRAINT `sys_log_fk_2` FOREIGN KEY (`sys_log_function_id`) REFERENCES `sys_log_functions` (`sys_log_function_id`),
    ADD CONSTRAINT `sys_log_fk_3` FOREIGN KEY (`sys_log_type_id`) REFERENCES `sys_log_types` (`sys_log_type_id`);

--
-- Constraints for table`sys_script_times`
--
ALTER TABLE `sys_script_times`
    ADD CONSTRAINT `sys_script_times_fk_1` FOREIGN KEY (`sys_script_id`) REFERENCES `sys_scripts` (`sys_script_id`);

--
-- Constraints for table`users`
--
ALTER TABLE `users`
    ADD CONSTRAINT `users_fk_1` FOREIGN KEY (`user_type_id`) REFERENCES `user_types` (`user_type_id`),
    ADD CONSTRAINT `users_fk_2` FOREIGN KEY (`user_profile_id`) REFERENCES `user_profiles` (`profile_id`);

--
-- Constraints for table`user_formulas`
--
ALTER TABLE `user_formulas`
    ADD CONSTRAINT `user_formulas_fk_4` FOREIGN KEY (`share_type_id`) REFERENCES `share_types` (`share_type_id`),
    ADD CONSTRAINT `user_formulas_fk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
    ADD CONSTRAINT `user_formulas_fk_2` FOREIGN KEY (`formula_type_id`) REFERENCES `formula_types` (`formula_type_id`),
    ADD CONSTRAINT `user_formulas_fk_3` FOREIGN KEY (`formula_id`) REFERENCES `formulas` (`formula_id`);

--
-- Constraints for table`user_formula_links`
--
ALTER TABLE `user_formula_links`
    ADD CONSTRAINT `user_formula_links_fk_1` FOREIGN KEY (`formula_link_id`) REFERENCES `formula_links` (`formula_link_id`),
    ADD CONSTRAINT `user_formula_links_fk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
    ADD CONSTRAINT `user_formula_links_fk_3` FOREIGN KEY (`link_type_id`) REFERENCES `formula_link_types` (`formula_link_type_id`);

--
-- Constraints for table`user_phrase_groups`
--
ALTER TABLE user_groups
    ADD CONSTRAINT `user_phrase_groups_fk_1` FOREIGN KEY (group_id) REFERENCES `groups` (group_id),
    ADD CONSTRAINT `user_phrase_groups_fk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table`user_phrase_group_word_links`
--
ALTER TABLE user_group_links
    ADD CONSTRAINT `user_phrase_group_word_links_fk_1` FOREIGN KEY (`phrase_group_word_link_id`) REFERENCES user_group_links (`phrase_group_word_link_id`),
    ADD CONSTRAINT `user_phrase_group_word_links_fk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table`user_phrase_group_triple_links`
--
ALTER TABLE `user_phrase_group_triple_links`
    ADD CONSTRAINT `user_phrase_group_triple_links_fk_1` FOREIGN KEY (`phrase_group_triple_link_id`) REFERENCES `phrase_group_triple_links` (`phrase_group_triple_link_id`),
    ADD CONSTRAINT `user_phrase_group_triple_links_fk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

-- --------------------------------------------------------

--
-- constraints for table sources
--
ALTER TABLE sources
    ADD CONSTRAINT source_name_uk UNIQUE (source_name),
    ADD CONSTRAINT sources_user_fk FOREIGN KEY (user_id) REFERENCES users (user_id),
    ADD CONSTRAINT sources_source_type_fk FOREIGN KEY (source_type_id) REFERENCES source_types (source_type_id);

--
-- constraints for table user_sources
--
ALTER TABLE user_sources
    ADD CONSTRAINT user_sources_source_fk FOREIGN KEY (source_id) REFERENCES sources (source_id),
    ADD CONSTRAINT user_sources_user_fk FOREIGN KEY (user_id) REFERENCES users (user_id),
    ADD CONSTRAINT user_sources_source_type_fk FOREIGN KEY (source_type_id) REFERENCES source_types (source_type_id);

--
-- Constraints for table`user_refs`
--
ALTER TABLE `user_refs`
    ADD CONSTRAINT `user_refs_fk_1` FOREIGN KEY (`ref_id`) REFERENCES `refs` (`ref_id`),
    ADD CONSTRAINT `user_refs_fk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table`user_values`
--
ALTER TABLE `user_values`
    ADD CONSTRAINT `user_values_fk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
    ADD CONSTRAINT `user_values_fk_2` FOREIGN KEY (`source_id`) REFERENCES `sources` (`source_id`),
    ADD CONSTRAINT `user_values_fk_3` FOREIGN KEY (`share_type_id`) REFERENCES `share_types` (`share_type_id`),
    ADD CONSTRAINT `user_values_fk_4` FOREIGN KEY (`protect_id`) REFERENCES `protection_types` (`protect_id`);

--
-- Constraints for table`user_value_time_series`
--
ALTER TABLE `user_value_time_series`
    ADD CONSTRAINT `user_value_time_series_fk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
    ADD CONSTRAINT `user_value_time_series_fk_2` FOREIGN KEY (`source_id`) REFERENCES `sources` (`source_id`),
    ADD CONSTRAINT `user_value_time_series_fk_3` FOREIGN KEY (`share_type_id`) REFERENCES `share_types` (`share_type_id`),
    ADD CONSTRAINT `user_value_time_series_fk_4` FOREIGN KEY (`protect_id`) REFERENCES `protection_types` (`protect_id`);

-- --------------------------------------------------------

--
-- constraints for table views
--

ALTER TABLE views
    ADD CONSTRAINT view_name_uk UNIQUE (view_name),
    ADD CONSTRAINT code_id_uk UNIQUE (code_id),
    ADD CONSTRAINT views_user_fk FOREIGN KEY (user_id) REFERENCES users (user_id),
    ADD CONSTRAINT views_view_type_fk FOREIGN KEY (view_type_id) REFERENCES view_types (view_type_id);

--
-- constraints for table user_views
--

ALTER TABLE user_views
    ADD CONSTRAINT user_views_view_fk FOREIGN KEY (view_id) REFERENCES views (view_id),
    ADD CONSTRAINT user_views_user_fk FOREIGN KEY (user_id) REFERENCES users (user_id),
    ADD CONSTRAINT user_views_language_fk FOREIGN KEY (language_id) REFERENCES languages (language_id),
    ADD CONSTRAINT user_views_view_type_fk FOREIGN KEY (view_type_id) REFERENCES view_types (view_type_id);

-- --------------------------------------------------------

--
-- constraints for table components
--

ALTER TABLE components
    ADD CONSTRAINT component_name_uk UNIQUE (component_name),
    ADD CONSTRAINT code_id_uk UNIQUE (code_id),
    ADD CONSTRAINT ui_msg_code_id_uk UNIQUE (ui_msg_code_id),
    ADD CONSTRAINT components_user_fk FOREIGN KEY (user_id) REFERENCES users (user_id),
    ADD CONSTRAINT components_component_type_fk FOREIGN KEY (component_type_id) REFERENCES component_types (component_type_id),
    ADD CONSTRAINT components_formula_fk FOREIGN KEY (formula_id) REFERENCES formulas (formula_id);

--
-- constraints for table user_components
--

ALTER TABLE user_components
    ADD CONSTRAINT user_components_component_fk FOREIGN KEY (component_id) REFERENCES components (component_id),
    ADD CONSTRAINT user_components_user_fk FOREIGN KEY (user_id) REFERENCES users (user_id),
    ADD CONSTRAINT user_components_component_type_fk FOREIGN KEY (component_type_id) REFERENCES component_types (component_type_id),
    ADD CONSTRAINT user_components_formula_fk FOREIGN KEY (formula_id) REFERENCES formulas (formula_id);

--
-- Constraints for table`user_component_links`
--
ALTER TABLE `user_component_links`
    ADD CONSTRAINT `user_component_links_fk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
    ADD CONSTRAINT `user_component_links_fk_2` FOREIGN KEY (`component_link_id`) REFERENCES `component_links` (`component_link_id`),
    ADD CONSTRAINT `user_component_links_fk_3` FOREIGN KEY (`position_type`) REFERENCES `component_position_types` (`component_position_type_id`);

--
-- Constraints for table`user_words`
--
ALTER TABLE `user_words`
    ADD CONSTRAINT `user_words_fk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
    ADD CONSTRAINT `user_words_fk_2` FOREIGN KEY (`phrase_type_id`) REFERENCES `phrase_types` (`phrase_type_id`),
    ADD CONSTRAINT `user_words_fk_3` FOREIGN KEY (`view_id`) REFERENCES `views` (`view_id`),
    ADD CONSTRAINT `user_words_fk_4` FOREIGN KEY (`word_id`) REFERENCES `words` (`word_id`);

--
-- Constraints for table`user_triples`
--
ALTER TABLE `user_triples`
    ADD CONSTRAINT `user_triples_fk_1` FOREIGN KEY (`triple_id`) REFERENCES `triples` (`triple_id`),
    ADD CONSTRAINT `user_triples_fk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table`values`
--
ALTER TABLE `values`
    ADD CONSTRAINT `values_fk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
    ADD CONSTRAINT `values_fk_2` FOREIGN KEY (`source_id`) REFERENCES `sources` (`source_id`),
    ADD CONSTRAINT `values_fk_3` FOREIGN KEY (`phrase_group_id`) REFERENCES `groups` (group_id),
    ADD CONSTRAINT `values_fk_4` FOREIGN KEY (`protect_id`) REFERENCES `protection_types` (`protect_id`);

--
-- Constraints for table`components`
--
ALTER TABLE `components`
    ADD CONSTRAINT `components_fk_2` FOREIGN KEY (`formula_id`) REFERENCES `formulas` (`formula_id`);

--
-- Constraints for table`component_links`
--
ALTER TABLE `component_links`
    ADD CONSTRAINT `component_links_fk_1` FOREIGN KEY (`view_id`) REFERENCES `views` (`view_id`),
    ADD CONSTRAINT `component_links_fk_2` FOREIGN KEY (`position_type`) REFERENCES `component_position_types` (`component_position_type_id`),
    ADD CONSTRAINT `component_links_fk_3` FOREIGN KEY (`component_id`) REFERENCES `components` (`component_id`);

--
-- Constraints for table`words`
--
ALTER TABLE `words`
    ADD CONSTRAINT `words_fk_1` FOREIGN KEY (`view_id`) REFERENCES `views` (`view_id`),
    ADD CONSTRAINT `words_fk_2` FOREIGN KEY (`phrase_type_id`) REFERENCES `phrase_types` (`phrase_type_id`);

--
-- Constraints for table`word_periods`
--
ALTER TABLE `word_periods`
    ADD CONSTRAINT `word_periods_fk_1` FOREIGN KEY (`word_id`) REFERENCES `words` (`word_id`);

/*!40101 SET CHARACTER_SET_CLIENT = @OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS = @OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION = @OLD_COLLATION_CONNECTION */;
