-- DATA Cleaning

SELECT *
FROM layoffs;

-- Creating a copy of raw data file

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;

SELECT *
FROM layoffs;

SELECT *
FROM layoffs_staging;


-- 1.Removing Duplicates

SELECT *,
Row_number() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off,'date') as row_num
FROM layoffs_staging; 

WITH duplicates_cte as
(
SELECT *,
Row_number() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,'date', stage,country, funds_raised_millions) as row_num
FROM layoffs_staging
)
DELETE 
FROM duplicates_cte
WHERE row_num > 1;

SELECT *
FROM layoffs_staging
WHERE company = 'casper';

-- Creating another table that has extra row and then deleting it where that row is equal to 2

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2;
 
 INSERT INTO layoffs_staging2
 SELECT *,
Row_number() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,'date', stage,country, funds_raised_millions) as row_num
FROM layoffs_staging;

SELECT *
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;  

SET SQL_SAFE_UPDATES = 0;

DELETE
FROM layoffs_staging2
WHERE  row_num > 1;

SELECT *
FROM layoffs_staging2;

-- 2. Standardizing data

SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = trim(company);

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'CRYPTO%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry = 'crypto%';

SELECT DISTINCT industry
FROM layoffs_staging2;

SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2
ORDER BY 1;

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2
WHERE country LIKE 'United States%'
ORDER BY 1;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT `date`
FROM layoffs_staging2;

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

SELECT `date`
FROM layoffs_staging2;

ALTER TABLE  layoffs_staging2
MODIFY COLUMN `date` DATE;

-- 3.Null Values and Blank Values

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT DISTINCT industry 
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';


SELECT * 
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

SELECT * 
FROM layoffs_staging2
WHERE company = 'Airbnb';

-- Self Join

SELECT t1.industry,t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
WHERE (t1.industry IS  NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS  NULL 
AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_staging2
WHERE company LIKE 'BALLY%';

-- 4. Removing Any Columns or Rows

SELECT *
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;





















































 
 
 
 
 
 
 
 











 




