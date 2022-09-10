CREATE TABLE IF NOT EXISTS `user` (
    `user_id` int(11) NOT NULL AUTO_INCREMENT,
    `guid` varchar(255) CHARACTER SET utf8 NOT NULL,
    `username` varchar(512) CHARACTER SET utf8 NOT NULL,
    `email` varchar(1024) CHARACTER SET utf8 DEFAULT NULL,
    `hashed_password` varchar(1024) CHARACTER SET utf8 NOT NULL,
    `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `disabled` tinyint(4) DEFAULT 1,
    `admin` tinyint(4) DEFAULT 0,
    PRIMARY KEY (`user_id`),
    UNIQUE KEY `user_id_UNIQUE` (`user_id`),
    UNIQUE KEY `guid_UNIQUE` (`guid`),
    UNIQUE KEY `username_UNIQUE` (`username`),
    KEY `idx_guid` (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
