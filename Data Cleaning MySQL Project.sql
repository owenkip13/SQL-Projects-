-- Data Cleaning 



SELECT * FROM layoffs; 

-- 1. Remove Duplicates 
-- 2. Standardize the Data 
-- 3. Null values or blank values 
-- 4. Remove any columns 



CREATE TABLE layoffs_staging 
LIKE layoffs; 

SELECT * FROM layoffs_staging; 

INSERT layoffs_staging
SELECT * FROM layoffs;

-- Removing Duplicates 

SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num 
FROM layoffs_staging;

WITH duplicate_cte AS 
(
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, location,  industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num 
FROM layoffs_staging
) 
SELECT * 
FROM duplicate_cte
WHERE row_num > 1; 

SELECT * FROM layoffs_staging
WHERE company = 'Casper';

WITH duplicate_cte AS 
(
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, location,  industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num 
FROM layoffs_staging
) 
DELETE 
FROM duplicate_cte
WHERE row_num > 1; 


SELECT * FROM layoffs_staging
WHERE company = 'Casper'; 


CREATE TABLE `layoffs_staging4` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL, 
  `row_num` IN T 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
 

SELECT * FROM layoffs_staging4;


INSERT INTO layoffs_staging4
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num 
FROM layoffs_staging;

DELETE 
FROM layoffs_staging2
WHERE row_num > 1; 

SELECT * FROM layoffs_staging4
WHERE row_num > 1; 

DELETE 
FROM layoffs_staging4
WHERE row_num > 1; 

SELECT * FROM layoffs_staging4
ORDER BY company; 

SELECT * FROM layoffs_staging4
WHERE company = 'Airbnb'; 



-- Remove Duplicates Done 

-- Standardizing Data - Finding issus and fixing them 

SELECT company, (TRIM(company)) FROM layoffs_staging4;

UPDATE layoffs_staging4
SET company = TRIM(company); 

SELECT DISTINCT industry FROM layoffs_staging4
ORDER BY 1;

SELECT * FROM layoffs_staging4
WHERE industry LIKE 'Crypto%'; 

UPDATE layoffs_staging4
SET industry = 'Crypto' 
WHERE industry LIKE 'Crypto%'; 

SELECT DISTINCT industry 
FROM layoffs_staging4; 

SELECT * FROM layoffs_staging4; 

SELECT distinct country FROM layoffs_staging4
WHERE country LIKE 'United States%'
ORDER BY 1; 

SELECT DISTINCT country , TRIM(TRAILING '.' FROM country)
FROM layoffs_staging4 
ORDER BY 1; 

UPDATE layoffs_staging4
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%'; 

SELECT DISTINCT country FROM layoffs_staging4; 

SELECT `date`, 
str_to_date(`date`, '%m/%d/%Y')
FROM layoffs_staging4; 

UPDATE layoffs_staging4
SET `date` = str_to_date(`date`, '%m/%d/%Y'); 


SELECT `date`date 
FROM layoffs_staging4; 

ALTER TABLE layoffs_staging4
MODIFY COLUMN `date` DATE; 

SELECT * FROM layoffs_staging4; 

SELECT COUNT(*) FROM layoffs_staging4; 

-- Null values or blank values 


SELECT * FROM layoffs_staging4
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL; 

UPDATE layoffs_staging4
SET industry = NULL 
WHERE industry = '';

SELECT DISTINCT industry FROM layoffs_staging4
WHERE industry is NULL 
OR industry = ''; 


SELECT * FROM layoffs_staging4
WHERE industry is NULL 
OR industry = ''; 

SELECT * FROM layoffs_staging4
WHERE company = 'Airbnb'; 


SELECT * FROM layoffs_staging3; 

SELECT * 
FROM layoffs_staging4 t1
JOIN layoffs_staging4 t2
	ON t1.company= t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging4 t1
JOIN layoffs_staging4 t2
	ON t1.company= t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

SELECT * FROM layoffs_staging4;


SELECT * FROM layoffs_staging4
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL; 

SELECT COUNT(*) FROM layoffs_staging3; 

DELETE 
FROM layoffs_staging4
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL; 

SELECT * FROM layoffs_staging4; 

ALTER TABLE layoffs_staging4 
DROP COLUMN row_num; 

SELECT * FROM layoffs_staging4 
ORDER BY company; 

