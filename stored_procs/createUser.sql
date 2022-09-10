DELIMITER $$

DROP procedure IF EXISTS `createUser`;

CREATE PROCEDURE `createUser`(
	IN `username` VARCHAR(512),
	IN `email` VARCHAR(1024),
	IN `hashed_password` VARCHAR(1024),
    IN `disabled` TINYINT(4),
	IN `admin` TINYINT(4)
)
BEGIN
	DECLARE guid VARCHAR(255);
	DECLARE user_guid_count INT(11);
	DECLARE user_username_count INT(11);

    START TRANSACTION;

		SET guid = (SELECT UUID());
        SET user_guid_count = (SELECT COUNT(*) FROM user u1 WHERE u1.guid = guid);
        SET user_username_count = (SELECT COUNT(*) FROM user u1 WHERE u1.username = username);

		IF (user_guid_count = 0 AND user_username_count = 0) THEN
			INSERT INTO user (guid, username, email, hashed_password, disabled, admin) VALUES (guid, username, email, hashed_password, disabled, admin);
            SELECT guid;
        END IF;

	COMMIT;
END$$

DELIMITER ;
