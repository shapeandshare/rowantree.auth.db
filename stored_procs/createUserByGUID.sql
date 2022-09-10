DELIMITER $$

DROP procedure IF EXISTS `createUserByGUID`;

CREATE PROCEDURE `createUserByGUID`(
	IN `guid` VARCHAR(255),
	IN `username` VARCHAR(16),
	IN `email` VARCHAR(255),
	IN `hashed_password` VARCHAR(255),
    IN `disabled` TINYINT(4),
	IN `admin` TINYINT(4)
)
BEGIN

	START TRANSACTION;
        SET @user_guid_count = (SELECT COUNT(*) FROM user WHERE guid = guid);
        SET @user_username_count = (SELECT COUNT(*) FROM user WHERE username = username);

		IF (@user_guid_count = 0 AND @user_username_count = 0) THEN
			INSERT INTO user (guid, username, email, hashed_password, disabled, admin) VALUES (guid, username, email, hashed_password, disabled, admin);
        END IF;

	COMMIT;
END$$

DELIMITER ;

