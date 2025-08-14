SELECT county,AVG(2015_deposits) AS average_deposits_2015
FROM chase
GROUP BY county
ORDER BY average_deposits_2015 DESC;