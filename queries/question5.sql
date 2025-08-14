SELECT branch_name,(2016_deposits - 2010_deposits) AS deposit_growth
FROM chase
ORDER BY deposit_growth DESC
LIMIT 5;