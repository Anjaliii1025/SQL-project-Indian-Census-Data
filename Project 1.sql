SELECT * FROM project1.dataset1;
SELECT * FROM project1.dataset2;

-- number of rows in dataset
SELECT COUNT(*) FROM project1.dataset1;
SELECT COUNT(*) FROM project1.dataset2;

-- dataset for jharkhand and bihar
SELECT * 
FROM project1.dataset1
WHERE State IN ('Jharkhand','Bihar');

SELECT * 
FROM project1.dataset2
WHERE State IN ('Jharkhand','Bihar');

-- population of India
SELECT SUM(Population)
FROM project1.dataset2;

-- AVERAGE GROWTH
SELECT State,AVG(Growth) AS avg_state_growth
FROM project1.dataset1
GROUP BY State
ORDER BY avg_state_growth;

-- top 3 state showing highest growth ratio
SELECT State,AVG(Growth) AS avg_state_growth
FROM project1.dataset1
GROUP BY State
ORDER BY avg_state_growth DESC
LIMIT 3;

-- average sex ratio
SELECT State,AVG(Sex_Ratio) AS avg_sex_ratio
FROM project1.dataset1
GROUP BY State
ORDER BY avg_sex_ratio;

-- bottom 3 state showing lowest sex ratio
SELECT State,AVG(Sex_Ratio) AS avg_sex_ratio
FROM project1.dataset1
GROUP BY State
ORDER BY avg_sex_ratio
LIMIT 3;

-- average literacy rate
SELECT State,ROUND(AVG(Literacy),0) AS avg_lit
FROM project1.dataset1
GROUP BY State HAVING avg_lit>90;

-- top and bottom 3 states in literacy rate
(SELECT State, ROUND(AVG(Literacy),0) AS avg_literacy_rate FROM project1.dataset1
    GROUP BY State ORDER BY avg_literacy_rate DESC
    LIMIT 3)
UNION
(SELECT State, ROUND(AVG(Literacy),0) AS avg_literacy_rate FROM project1.dataset1
    GROUP BY State ORDER BY avg_literacy_rate ASC
    LIMIT 3);

 -- states starting with letter a
 SELECT DISTINCT State FROM project1.dataset1 WHERE LOWER(State) like 'a%' or LOWER(State) like 'b%';
 
-- joining both table
SELECT a.District, a.State, a.Sex_ratio/1000, b.Population
FROM project1.dataset1 a
INNER JOIN project1.dataset2 b ON a.District = b.District
LIMIT 1000;

-- NO. of males and female
SELECT d.State, SUM(d.Males) total_male, SUM(d.Females) total_females FROM
(SELECT c.District, c.State,c.Population/(c.Sex_Ratio +1) Males,
(c.Population * c.Sex_Ratio)/(c.Sex_Ratio +1) Females FROM
(SELECT a.District, a.State, a.Sex_Ratio/1000 as Sex_Ratio, b.Population
FROM project1.dataset1 a
INNER JOIN project1.dataset2 b ON a.District = b.District
LIMIT 1000) c) d
GROUP BY d.State;

-- total literacy rate
SELECT d.State, SUM(d.literate_people) Total_Literate_people,
SUM(d.illiterate_people) Total_Illiterate_people FROM
(SELECT c.District, c.State, c.Literate * Population as literate_people,
(c.Literate-1)* Population as illiterate_people FROM
(SELECT a.District, a.State, a.Literacy as Literate, b.Population
FROM project1.dataset1 a
INNER JOIN project1.dataset2 b ON a.District = b.District
LIMIT 1000) c) d
GROUP BY d.State;


-- population in previous cencus 
SELECT ROUND(SUM(d.Total_previous_census), 0) AS Grand_Total_Previous_Census, 
SUM(d.Total_census_population) AS Grand_Total_Census_Population FROM 
(SELECT d.State, ROUND(SUM(d.Previous_cencus), 0) AS Total_previous_census, 
SUM(d.Current_cencus) AS Total_census_population FROM 
(SELECT c.State, c.Population / (1 + c.gro) AS Previous_cencus, c.Population AS Current_cencus FROM
(SELECT a.State, a.Growth / 100 AS gro, b.Population FROM project1.dataset1 a 
INNER JOIN project1.dataset2 b ON a.District = b.District 
LIMIT 1000) c ) d GROUP BY d.State) d LIMIT 1;


-- population vs area

SELECT g.total_area/g.Grand_Total_previous_census AS previous_population_vs_area, g.total_area/g.Grand_Total_census_population AS current_population_vs_area FROM
(SELECT q.*, r.total_area FROM

(SELECT '1' as keyy,n.* FROM
(SELECT ROUND(SUM(d.Total_previous_census), 0) AS Grand_Total_Previous_Census, 
SUM(d.Total_census_population) AS Grand_Total_Census_Population FROM 
(SELECT d.State, ROUND(SUM(d.Previous_cencus), 0) AS Total_previous_census, 
SUM(d.Current_cencus) AS Total_census_population FROM 
(SELECT c.State, c.Population / (1 + c.gro) AS Previous_cencus, c.Population AS Current_cencus FROM
(SELECT a.State, a.Growth / 100 AS gro, b.Population FROM project1.dataset1 a 
INNER JOIN project1.dataset2 b ON a.District = b.District 
LIMIT 1000) c ) d GROUP BY d.State) d LIMIT 1) n) q

INNER JOIN

(SELECT '1' as keyy,z.* FROM 
(SELECT SUM(Area_km2) total_area FROM project1.dataset2)z)r on q.keyy = r.keyy) g;


-- windows function
SELECT a.* FROM
(SELECT District, State, Literacy , RANK() 
OVER(PARTITION BY State ORDER BY Literacy DESC) rnk FROM project1.dataset1) a
WHERE a.rnk in (1,2,3) ORDER BY State;






























































































