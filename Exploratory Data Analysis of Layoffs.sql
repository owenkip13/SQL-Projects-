-- Exploratroy Data Analysis 

SELECT * FROM layoffs_staging4; 

SELECT MAX(total_laid_off) FROM layoffs_staging4; 

SELECT MAX(total_laid_off), MAX(percentage_laid_off) FROM layoffs_staging4; 

SELECT * FROM layoffs_staging4 
WHERE percentage_laid_off = 1;

SELECT * FROM layoffs_staging4 
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

SELECT * FROM layoffs_staging4 
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;   

SELECT company, SUM(total_laid_off) 
FROM layoffs_staging4 
GROUP BY company
ORDER BY 2 DESC; 

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging4;

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging4 
GROUP BY industry
ORDER BY 2 DESC; 

SELECT country, SUM(total_laid_off)
FROM layoffs_staging4 
GROUP BY country
ORDER BY 2 DESC; 

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging4 
GROUP BY YEAR(`date`)
ORDER BY 1 DESC; 

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging4 
GROUP BY stage
ORDER BY 2 DESC; 

SELECT company, AVG(percentage_laid_off)
FROM layoffs_staging4 
GROUP BY company
ORDER BY 2 DESC; 

-- Rolling Total Layoffs 

SELECT * FROM layoffs_staging4;

SELECT substring(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging4
WHERE substring(`date`,1,7) IS NOT NULL 
GROUP BY `MONTH`
ORDER BY 1 ASC; 


SELECT * 
FROM layoffs_staging4;

WITH Rolling_Total AS 
( 
SELECT substring(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off 
FROM layoffs_staging4
WHERE substring(`date`,1,7) IS NOT NULL 
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off,
 SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

SELECT company, SUM(total_laid_off) 
FROM layoffs_staging4 
GROUP BY company
ORDER BY 2 DESC;

--  Comany, by the year, and how many people they let go 

SELECT company, YEAR(`date`), SUM(total_laid_off) 
FROM layoffs_staging4 
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC; 

-- 

WITH Company_Year (company, years, total_laid_off) AS 
(
SELECT company, YEAR(`date`), SUM(total_laid_off) 
FROM layoffs_staging4 
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS 
(SELECT *, DENSE_RANK () OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking 
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT * 
FROM Company_Year_Rank
WHERE Ranking <= 5;
















