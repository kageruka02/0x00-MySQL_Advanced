-- SQL script that creates a stored procedure AddBonus that adds a new correction for a student.


-- DELIMITER $$;
-- CREATE PROCEDURE AddBonus(IN user_id INT, IN project_name VARCHAR(255), IN score INT )
-- BEGIN
-- 	IF NOT EXISTS(SELECT name FROM projects WHERE name=project_name) THEN
-- 		INSERT INTO projects (name) VALUES (project_name);
-- 	END IF;
-- 	INSERT INTO corrections (user_id, project_id, score)
-- 	VALUES (user_id, (SELECT id from projects WHERE name=project_name), score);
-- END;$$
-- DELIMITER ;

DELIMITER $$
CREATE PROCEDURE AddBonus(IN user_id INT, IN project_name VARCHAR(255), IN score INT)
BEGIN
	DECLARE p_id int;
    SELECT id into p_id from projects where name = project_name;
    IF P_id is NOT NULL THEN
		INSERT INTO corrections (user_id, project_id, score) VALUES (user_id, p_id, score);
	ELSEIF p_id is NULL THEN
		INSERT INTO projects (name) VALUES (project_name);
        SET @newproject = LAST_INSERT_ID();
        INSERT INTO corrections (user_id, project_id, score) VALUES (user_id, @newproject, score);
	END IF;
END  $$