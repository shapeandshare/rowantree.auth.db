DELIMITER $$

DROP procedure IF EXISTS `createUser`;

CREATE PROCEDURE `createUser`(
	IN username VARCHAR(16),
	IN email VARCHAR(255),
	IN hashed_password VARCHAR(255),
	IN disabled TINYINT(4),
	IN admin TINYINT(4)
)
BEGIN
	-- Creates a new user with a new random UUID
	SET @guid = (SELECT UUID());
    CALL createUserByGUID(@guid, username, email, hashed_password, disabled, admin);
    SELECT @guid;
END$$

DELIMITER ;
