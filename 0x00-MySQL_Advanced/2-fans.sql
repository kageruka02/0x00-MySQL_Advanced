-- Write SQL script that ranks country origins of bands
-- Ordered by the number of (non-unique) fans
-- Column must be origin and nb_fans
-- Script can be executed on any databas

SELECT origin, SUM(fans) AS NB_FANS
FROM metal_bands
GROUP BY origin
ORDER BY NB_FANS DESC;