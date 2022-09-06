DELIMITER $$

DROP procedure IF EXISTS `getUserByGUID`;

CREATE PROCEDURE `getUserByGUID`(
	IN guid VARCHAR(255)
)
BEGIN
    SELECT *
        FROM user u1
    WHERE u1.guid = guid;
END$$

DELIMITER ;
