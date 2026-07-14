select company
from layoffs
GROUP BY company;

CREATE table layoff_temp
like layoffs;


select * 
FROM layoff_temp
ORDER BY company ASC;

WITH cte AS (
SELECT *, ROW_NUMBER() OVER(PARTITION BY company,location,`date`,stage,percentage_laid_off
,total_laid_off,industry,country) as row_num
FROM layoff_temp
)
 
DELETE FROM layoff_temp2
WHERE row_num > 1;

SELECT * 
FROM layoff_temp2;


-- STANDARDIZING

SELECT company,TRIM(company)
from layoff_temp2;

UPDATE layoff_temp2 
set company = TRIM(company);

SELECT distinct(industry) FROM layoff_temp2 order by industry asc;

UPDATE layoff_temp2
set industry = 'Crypto'
WHERE industry LIKE '%Crypto%';

SELECT country,TRIM(TRAILING  '.' FROM country)
FROM layoff_temp2;

UPDATE layoff_temp2
SET country =TRIM(TRAILING  '.' FROM country)
where country LIKE 'United States%';

UPDATE layoff_temp2 
SET `date` = STR_TO_DATE(`date`,'%m/%d/%Y');

ALTER TABLE layoff_temp2
MODIFY COLUMN `date` DATE;


-- Populate the industry field with the same type
UPDATE layoff_temp2
set industry = NULL
WHERE industry = '';

select count(*)  from layoffs;

SELECT * 
FROM layoff_temp2 t1
JOIN layoff_temp2 t2
	on t1.company = t2.company
WHERE (t2.industry IS NULL OR t2.industry ='')
AND t1.industry IS NOT NULL;



UPDATE layoff_temp2  t1
JOIN layoff_temp2 t2
	on t1.company = t2.company
SET t2.industry = t1.industry
WHERE t2.industry IS NULL 
AND t1.industry IS NOT NULL;

alter table layoff_temp2
DROP COLUMN row_num;

