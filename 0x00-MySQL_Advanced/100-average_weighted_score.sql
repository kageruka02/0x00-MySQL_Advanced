-- Create the ComputeAverageWeightedScoreForUser procedure
DELIMITER $$

CREATE PROCEDURE ComputeAverageWeightedScoreForUser(IN user_id INT)
BEGIN
    DECLARE totalWeightedScore FLOAT;
    DECLARE totalWeight INT;
    
    -- Calculate the total weighted score and total weight for the user
    SELECT SUM(c.score * p.weight) INTO totalWeightedScore
    FROM corrections c
    JOIN projects p ON c.project_id = p.id
    WHERE c.user_id = user_id;
    
    SELECT SUM(p.weight) INTO totalWeight
    FROM corrections c
    JOIN projects p ON c.project_id = p.id
    WHERE c.user_id = user_id;
    
    -- Update the user's average score with the weighted average
    IF totalWeight > 0 THEN
        UPDATE users
        SET average_score = totalWeightedScore / totalWeight
        WHERE id = user_id;
    ELSE
        UPDATE users
        SET average_score = 0
        WHERE id = user_id;
    END IF;
END $$

DELIMITER ;