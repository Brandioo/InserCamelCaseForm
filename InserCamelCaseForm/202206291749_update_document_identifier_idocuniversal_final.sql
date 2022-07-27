-- liquibase formatted sql
-- changeset bcitozi:1

use `schema`;
DROP FUNCTION IF EXISTS `camel_case`;

DELIMITER $$

CREATE FUNCTION `camel_case`(str varchar(50)) RETURNS varchar(50)
BEGIN
DECLARE n, pos INT DEFAULT 1;
DECLARE sub, proper VARCHAR(50) DEFAULT '';
if length(trim(str)) > 0 then
    WHILE pos > 0 DO
        set str = REPLACE(str, '-', ' ');
        set str = REPLACE(str, '/', ' ');
        set pos = locate(' ',trim(str),n);
        if pos = 0 then
            set sub = lower(trim(substr(trim(str),n)));
else
            set sub = lower(trim(substr(trim(str),n,pos-n)));
end if;
        set proper = concat_ws('', proper, concat(upper(left(sub,1)),substr(sub,2)));
        set n = pos + 1;
END WHILE;
end if;
RETURN trim(CONCAT(LCASE(LEFT(proper, 1)), SUBSTRING(proper, 2)));
END $$

DELIMITER ;

UPDATE `schema`.`table` SET `schema`.`table`.`column`= camel_case(documentname);
UPDATE `schema`.`table` SET `schema`.`table`.`column`= camel_case(name);

-- rollback UPDATE `schema`.`table` SET `schema`.`table`.`column`= "";
-- rollback UPDATE `schema`.`table` SET `schema`.`table`.`column`= "";
-- rollback DROP FUNCTION `schema`.`camel_case`;
