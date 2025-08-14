SELECT city,SUM(2016_deposits) - SUM(2010_deposits) AS deposit_difference
FROM chase
GROUP BY city
ORDER BY deposit_difference DESC;