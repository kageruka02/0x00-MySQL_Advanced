-- Create the ComputeAverageWeightedScoreForUsers procedure
DELIMITER $$

CREATE PROCEDURE ComputeAverageWeightedScoreForUsers()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE userId INT;
    
    -- Declare cursor for iterating over user IDs
    DECLARE userCursor CURSOR FOR SELECT id FROM users;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN userCursor;
    userLoop: LOOP
        FETCH userCursor INTO userId;
        IF done THEN
            LEAVE userLoop;
        END IF;
        
        DECLARE totalWeightedScore FLOAT DEFAULT 0;
        DECLARE totalWeight INT DEFAULT 0;

        -- Calculate the total weighted score and total weight for the user
        SELECT SUM(c.score * p.weight), SUM(p.weight) 
        INTO totalWeightedScore, totalWeight
        FROM corrections c
        JOIN projects p ON c.project_id = p.id
        WHERE c.user_id = userId;

        -- Update the user's average score with the weighted average
        IF totalWeight > 0 THEN
            UPDATE users
            SET average_score = totalWeightedScore / totalWeight
            WHERE id = userId;
        ELSE
            UPDATE users
            SET average_score = 0
            WHERE id = userId;
        END IF;
    END LOOP;

    CLOSE userCursor;
END $$

DELIMITER ;