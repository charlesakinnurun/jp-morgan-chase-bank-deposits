SELECT SUBSTR(established_date,1,4) AS establishment_year,COUNT(*) AS number_of_branches
FROM chase
GROUP BY establishment_year
ORDER BY establishment_year;