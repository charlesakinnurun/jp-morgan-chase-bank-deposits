SELECT state,COUNT(*) AS branch_count
FROM chase
GROUP BY state
ORDER BY branch_count DESC
LIMIT 1;