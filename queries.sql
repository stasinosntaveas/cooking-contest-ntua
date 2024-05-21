--------------------------------------------------------------------------------------------------------------------------------
-- QUERY 12

WITH ranked_recipes AS (
	SELECT
	SUM(r.difficulty) AS total_difficulty, ee.season_year, ee.episode_id
	FROM episode_expansion AS ee
	INNER JOIN recipes AS r ON ee.recipe_id = r.recipe_id
	where ee.is_judge = '0'
	GROUP BY ee.season_year, ee.episode_id
	),
min_ranked_recipe AS (
	SELECT
	MIN(total_difficulty) AS min_total_difficulty
	FROM ranked_recipes
	)
SELECT *
FROM ranked_recipes AS rr
INNER JOIN min_ranked_recipe AS mrr
ON rr.total_difficulty = mrr.min_total_difficulty; 

--------------------------------------------------------------------------------------------------------------------------------
-- QUERY 13

WITH ranked_episodes AS (
	SELECT
	ee.season_year,
	ee.episode_id,
	SUM(CASE
		WHEN c.cooker_rank = 'C' THEN 1
		WHEN c.cooker_rank = 'B' THEN 2
		WHEN c.cooker_rank = 'A' THEN 3
		WHEN c.cooker_rank = 'sous-chef' THEN 4
		WHEN c.cooker_rank = 'chef' THEN 5
		ELSE 0
	END) AS total_rank
	FROM episode_expansion AS ee
	INNER JOIN cooker AS c ON ee.cooker_id = c.cooker_id
	GROUP BY ee.season_year, ee.episode_id
	),
min_ranked_episodes AS (
	SELECT
	MIN(total_rank) AS min_total_rank
	FROM ranked_episodes
	)
SELECT re.*
FROM ranked_episodes AS re
INNER JOIN min_ranked_episodes AS mre
ON re.total_rank = mre.min_total_rank;

--------------------------------------------------------------------------------------------------------------------------------
-- QUERY 14

SELECT topics_name, MAX(topic_count)
FROM (
    SELECT rtr.topics_id, COUNT(*) AS topic_count, rt.topics_name
    FROM episode_expansion AS ee
    INNER JOIN recipe_topics_recipes AS rtr ON ee.recipe_id = rtr.recipe_id
    INNER JOIN recipe_topics AS rt ON rt.topics_id = rtr.topics_id
    GROUP BY rtr.topics_id
) AS res;

--------------------------------------------------------------------------------------------------------------------------------
-- QUERY 15

SELECT f.food_group_name 
FROM food_group AS f
WHERE f.food_group_id NOT IN (
    SELECT ci.food_group_id
    FROM episode_expansion AS ee
    INNER JOIN recipes_ingredients AS ri ON ee.recipe_id = ri.recipe_id
    INNER JOIN cooking_ingredients AS ci ON ci.ingredients_id = ri.ingredients_id
    GROUP BY ci.food_group_id
);

----------------------------------------------------------------------------------------------------------------------------------------------------------
-- QUERY 11

select *
from (SELECT SUM(score) AS score, contestant_id, judge_id
FROM (
    SELECT
        CASE
            WHEN ee1.eval1 IS NOT NULL THEN ee2.eval1
            WHEN ee1.eval2 IS NOT NULL THEN ee2.eval2
            WHEN ee1.eval3 IS NOT NULL THEN ee2.eval3
            ELSE 0
        END AS score,
        ee2.cooker_id AS contestant_id,
        ee1.cooker_id AS judge_id
    FROM
        episode_expansion ee1
    INNER JOIN episode_expansion ee2 ON ee1.season_year = ee2.season_year 
                                      AND ee1.episode_id = ee2.episode_id 
                                      AND ee1.is_judge = 1 
                                      AND ee2.is_judge = 0
) AS res
GROUP BY contestant_id, judge_id) as temp
ORDER BY score DESC
LIMIT 5;

--------------------------------------------------------------------------------------------------------------------------------
    SELECT
        CASE
            WHEN ee1.eval1 IS NOT NULL THEN ee2.eval1
            WHEN ee1.eval2 IS NOT NULL THEN ee2.eval2
            WHEN ee1.eval3 IS NOT NULL THEN ee2.eval3
            ELSE 0
        END AS score,
        ee2.cooker_id AS contestant_id,
        ee1.cooker_id AS judge_id
    FROM
        episode_expansion ee1
    INNER JOIN episode_expansion ee2 ON ee1.season_year = ee2.season_year 
                                      AND ee1.episode_id = ee2.episode_id 
                                      AND ee1.is_judge = 1 
                                      AND ee2.is_judge = 0
	ORDER BY contestant_id, judge_id;
--------------------------------------------------------------------------------------------------------------------------------


SELECT
re.ingredients_id, ee.recipe_id, ee.season_year
from episode_expansion ee
inner join recipes_ingredients re on ee.recipe_id = re.recipe_id;




SELECT ni.carbonhydrates , irs.quantity, irs.recipe_id, irs.season_year
FROM nutritions_info ni
INNER JOIN (
    SELECT re.ingredients_id, re.quantity, ee.recipe_id, ee.season_year
    FROM episode_expansion ee
    INNER JOIN recipes_ingredients re ON ee.recipe_id = re.recipe_id
) irs ON ni.ingredients_id = irs.ingredients_id
order by irs.quantity desc;

--------------------------------------------------------------------------------------------------------------------------------
-- QUERY 9

SELECT irs.season_year, SUM(ni.carbonhydrates * irs.quantity)/100 AS total_carbonhydrates
FROM nutritions_info ni
INNER JOIN (
    SELECT re.ingredients_id, re.quantity, ee.season_year
    FROM episode_expansion ee
    INNER JOIN recipes_ingredients re ON ee.recipe_id = re.recipe_id and ee.is_judge = 0
) irs ON ni.ingredients_id = irs.ingredients_id
group by irs.season_year;

--------------------------------------------------------------------------------------------------------------------------------
-- QUERY 10

WITH temp AS (
    SELECT ee.season_year, r.ethnic_id, COUNT(*) AS freq
    FROM episode_expansion AS ee
    INNER JOIN recipes AS r ON ee.recipe_id = r.recipe_id
    WHERE ee.is_judge = 0
    GROUP BY ee.season_year, r.ethnic_id
),  two_year_freq as (
SELECT t1.season_year, t1.ethnic_id, (t1.freq + t2.freq) AS total_freq
FROM temp AS t1
    INNER JOIN temp as t2 ON t1.season_year = t2.season_year-1 AND t1.ethnic_id = t2.ethnic_id
    WHERE t1.freq >= 3 AND t2.freq >= 3
)
SELECT CONCAT(w1.season_year, '-', w1.season_year+1) AS PERI0D, w1.ethnic_id, w2.ethnic_id, w1.total_freq
FROM two_year_freq AS w1 INNER JOIN two_year_freq AS w2 ON w1.season_year = w2.season_year
WHERE w1.total_freq = w2.total_freq AND w1.ethnic_id < w2.ethnic_id;

--------------------------------------------------------------------------------------------------------------------------------
-- QUERY 6

WITH temp1 AS (
    SELECT rt1.recipe_id, rt1.type_meal_id AS t1, rt2.type_meal_id AS t2
    FROM recipes_type_meal AS rt1 INNER JOIN recipes_type_meal as rt2 ON rt1.recipe_id = rt2.recipe_id 
    WHERE rt1.type_meal_id < rt2.type_meal_id
), temp2 AS (
    SELECT recipe_id, COUNT(recipe_id) AS freq
    FROM episode_expansion
    WHERE is_judge = 0
    GROUP BY recipe_id
), temp3 AS (
    SELECT t1.t1, t1.t2, SUM(t2.freq) AS freq
    FROM temp1 as t1
    INNER JOIN temp2 AS t2 ON t1.recipe_id = t2.recipe_id
    GROUP BY t1.t1, t1.t2
    ORDER BY freq DESC
    LIMIT 3
), temp4 as (
    SELECT tm.type_meal_name as t1, t3.t2, t3.freq
    FROM temp3 AS t3
    INNER JOIN type_meal AS tm ON t3.t1 = tm.type_meal_id
)
SELECT t1, tn.type_meal_name, t4.freq
FROM temp4 AS t4
INNER JOIN type_meal AS tn ON t4.t2 = tn.type_meal_id;

--------------------------------------------------------------------------------------------------------------------------------
-- QUERY 6B

WITH temp1 AS (
    SELECT rt1.recipe_id, rt1.type_meal_id AS t1, rt2.type_meal_id AS t2
    FROM recipes_type_meal AS rt1 INNER JOIN recipes_type_meal as rt2 FORCE INDEX (fk_recipes_type_meal) ON rt1.recipe_id = rt2.recipe_id 
    WHERE rt1.type_meal_id < rt2.type_meal_id
), temp2 AS (
    SELECT recipe_id, COUNT(recipe_id) AS freq
    FROM episode_expansion FORCE INDEX (fk_episode_expansion3, idx_is_jugde)
    WHERE is_judge = 0
    GROUP BY recipe_id
), temp3 AS (
    SELECT t1.t1, t1.t2, SUM(t2.freq) AS freq
    FROM temp1 as t1
    INNER JOIN temp2 AS t2 ON t1.recipe_id = t2.recipe_id
    GROUP BY t1.t1, t1.t2
    ORDER BY freq DESC
    LIMIT 3
), temp4 as (
    SELECT tm.type_meal_name as t1, t3.t2, t3.freq
    FROM temp3 AS t3
    INNER JOIN type_meal AS tm ON t3.t1 = tm.type_meal_id
)
SELECT t1, tn.type_meal_name, t4.freq
FROM temp4 AS t4
INNER JOIN type_meal AS tn ON t4.t2 = tn.type_meal_id;

--------------------------------------------------------------------------------------------------------------------------------
-- QUERY 8

WITH temp AS (
    SELECT ee.season_year, ee.episode_id, COUNT(DISTINCT ri.equipment_id) AS Equipment
    FROM episode_expansion AS ee
    INNER JOIN recipes_equipment AS ri ON ee.recipe_id = ri.recipe_id
    WHERE ee.is_judge = 0
    GROUP BY ee.season_year, ee.episode_id
)
SELECT season_year, episode_id, MAX(Equipment) AS res
FROM temp;
