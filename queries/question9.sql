SELECT branch_name,established_date,acquired_date
FROM chase
WHERE established_date < acquired_date;