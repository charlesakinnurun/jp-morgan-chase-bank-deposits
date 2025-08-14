SELECT state,SUM(2016_deposits) AS total_deposits_2016
FROM chase
GROUP BY state
ORDER BY total_deposits_2016 DESC;