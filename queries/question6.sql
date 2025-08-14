SELECT branch_name,established_date
FROM chase
WHERE SUBSTR(established_date,1,4) > "2000" AND state = "FL";