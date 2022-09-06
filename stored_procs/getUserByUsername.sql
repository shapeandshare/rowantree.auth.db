DELIMITER $$

DROP procedure IF EXISTS `getUserByUsername`;

CREATE PROCEDURE `getUserByUsername`(
	IN username VARCHAR(16)
)
BEGIN
    SELECT *
        FROM user u1
    WHERE u1.username = username;
END$$

DELIMITER ;
