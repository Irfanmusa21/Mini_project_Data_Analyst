SELECT * FROM table_ds;

-- 1. Apakah ada data yang null?
SELECT * FROM table_ds WHERE work_year IS NULL
OR experience_level IS NULL
OR employment_type IS NULL
OR job_title IS NULL
OR salary IS NULL
OR salary_currency IS NULL
OR salary_in_usd IS NULL
OR employee_residence IS NULL
OR remote_ratio IS NULL
OR company_location IS NULL
OR company_size IS NULL;
-- 2. Job title apa saja yang ada?
SELECT DISTINCT job_title FROM table_ds ORDER BY job_title;
-- 3. Job title apa saja yang berkaitan dengan Data Analysis?
SELECT DISTINCT job_title FROM table_ds 
WHERE job_title LIKE '%Data Analyst%' ORDER BY job_title;
-- 4. Berapa jumlah rata-rata gaji Data Analysis?
SELECT AVG(salary_in_usd) FROM table_ds;
-- Rata-rata bulanan dalam rupiah
SELECT (AVG(salary_in_usd)*15000)/12 AS avg_sal_rupiah_monthly FROM table_ds;
-- Rata-rata berdasarkan experience level
SELECT experience_level,
(AVG(salary_in_usd)*15000)/12 AS avg_sal_rupiah_monthly 
FROM table_ds GROUP BY experience_level;
-- Rata-rata berdasarkan experience level dan jenis employment
SELECT experience_level, employment_type,
(AVG(salary_in_usd)*15000)/12 AS avg_sal_rupiah_monthly 
FROM table_ds GROUP BY experience_level, employment_type
ORDER BY experience_level;
-- 5. Rata-rata gaji data analysis dari tiap negara dengan pengalaman baru atau mid
SELECT company_location,
AVG(salary_in_usd)
FROM table_ds
WHERE job_title LIKE '%Data Analyst%'
    AND employment_type = 'FT'
    AND experience_level IN ('EN', 'MI')
GROUP BY company_location;
-- 6. Kenaikan gaji data analysis tiap tahun untuk pengalaman baru dan mid
WITH ds_1 AS(
    SELECT work_year,
        AVG(salary_in_usd) sal_in_usd_EN
    FROM table_ds
    WHERE
        employment_type = 'FT'
        AND experience_level = 'EN'
        AND job_title LIKE '%Data Analyst%'
    GROUP BY work_year
), ds_2 AS (
    SELECT work_year,
        AVG(salary_in_usd) sal_in_usd_MI
    FROM table_ds
    WHERE
        employment_type = 'FT'
        AND experience_level = 'MI'
        AND job_title LIKE '%Data Analyst%'
    GROUP BY work_year
) SELECT ds_1.work_year, ds_1.sal_in_usd_EN, ds_2.sal_in_usd_MI 
FROM ds_1 
LEFT OUTER JOIN ds_2 
    ON ds_1.work_year = ds_2.work_year;
    
-- 1. Persebaran tempat kerja data analyst pada tahun 2021
SELECT company_size, job_title,
    Count(job_title)
FROM table_ds
WHERE job_title LIKE 'Data Analyst'
AND work_year = 2021
GROUP BY job_title, company_size
ORDER BY company_size;

-- 2. Rata-rata gaji full time data analyst berdasarkan tingkat pengalaman
SELECT experience_level, job_title,
AVG(salary_in_usd)
FROM table_ds
WHERE job_title LIKE 'Data Analyst'
    AND employment_type = 'FT'
GROUP BY job_title, experience_level
ORDER BY avg;

-- 3. Tren rata-rata gaji data analyst
SELECT job_title, work_year,
    AVG(salary_in_usd)
FROM table_ds
WHERE job_title LIKE 'Data Analyst'
GROUP BY job_title, work_year
ORDER BY work_year;