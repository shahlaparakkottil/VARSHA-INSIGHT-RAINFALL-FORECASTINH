USE rainfall_project;

SHOW TABLES;

SELECT * 
FROM cleaned_rainfall_dataset
LIMIT 10;

-- Total records
SELECT COUNT(*) AS Total_Records
FROM cleaned_rainfall_dataset;

-- Rainfall category count
SELECT Rainfall_Category,
       COUNT(*) AS Total_Records
FROM cleaned_rainfall_dataset
GROUP BY Rainfall_Category;

-- Top 10 highest average rainfall subdivisions
SELECT SUBDIVISION,
       ROUND(AVG(ANNUAL), 2) AS Avg_Rainfall
FROM cleaned_rainfall_dataset
GROUP BY SUBDIVISION
ORDER BY Avg_Rainfall DESC
LIMIT 10;

-- Top 10 lowest average rainfall subdivisions
SELECT SUBDIVISION,
       ROUND(AVG(ANNUAL), 2) AS Avg_Rainfall
FROM cleaned_rainfall_dataset
GROUP BY SUBDIVISION
ORDER BY Avg_Rainfall ASC
LIMIT 10;

-- Drought count by subdivision
SELECT SUBDIVISION,
       COUNT(*) AS Drought_Years
FROM cleaned_rainfall_dataset
WHERE Rainfall_Category = 'Drought'
GROUP BY SUBDIVISION
ORDER BY Drought_Years DESC;

-- Heavy rainfall count by subdivision
SELECT SUBDIVISION,
       COUNT(*) AS Heavy_Rainfall_Years
FROM cleaned_rainfall_dataset
WHERE Rainfall_Category = 'Heavy Rainfall'
GROUP BY SUBDIVISION
ORDER BY Heavy_Rainfall_Years DESC;

-- Average rainfall by decade
SELECT FLOOR(YEAR / 10) * 10 AS Decade,
       ROUND(AVG(ANNUAL), 2) AS Avg_Rainfall
FROM cleaned_rainfall_dataset
GROUP BY Decade
ORDER BY Decade;

-- Rank subdivisions by average rainfall
SELECT SUBDIVISION,
       ROUND(AVG(ANNUAL), 2) AS Avg_Rainfall,
       RANK() OVER(ORDER BY AVG(ANNUAL) DESC) AS Rainfall_Rank
FROM cleaned_rainfall_dataset
GROUP BY SUBDIVISION;

-- Kerala rainfall history
SELECT YEAR,
       ANNUAL,
       Rainfall_Category
FROM cleaned_rainfall_dataset
WHERE SUBDIVISION = 'Kerala'
ORDER BY YEAR;

-- Kerala drought years
SELECT YEAR,
       ANNUAL,
       Rainfall_Category
FROM cleaned_rainfall_dataset
WHERE SUBDIVISION = 'Kerala'
AND Rainfall_Category = 'Drought'
ORDER BY YEAR;
