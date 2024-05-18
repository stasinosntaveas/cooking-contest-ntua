DROP SCHEMA IF EXISTS `cooking_contest_ntua`;
CREATE SCHEMA `cooking_contest_ntua`;
USE masterchef;



DROP TABLE IF EXISTS food_group;
CREATE TABLE food_group (
	food_group_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    food_group_name VARCHAR(100) NOT NULL,
    food_group_description VARCHAR(500) NOT NULL,
    image varchar(100) not null check (image like 'https://%'),
    image_caption varchar(100) not null,
    PRIMARY KEY (food_group_id)
);

#CREATE UNIQUE INDEX food_group_pk ON food_group (food_group_id);

DROP TABLE IF EXISTS cooking_ingredients;
CREATE TABLE cooking_ingredients (
	ingredients_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    ingredients_name VARCHAR(100) NOT NULL,
    measuring_herd VARCHAR(100) NOT NULL,
    food_group_id INT UNSIGNED NOT NULL,
    image varchar(100) not null check (image like 'https://%'),
    image_caption varchar(100) not null,
    PRIMARY KEY (ingredients_id ,food_group_id),
    CONSTRAINT fk_food_group FOREIGN KEY (food_group_id) references food_group(food_group_id)
    ON UPDATE NO ACTION ON DELETE RESTRICT
);

#CREATE UNIQUE INDEX cooking_ingredients_pk ON cooking_ingredients(ingredients_id);
#CREATE INDEX fk_food_group ON cooking_ingredients(food_group_id);


DROP TABLE IF EXISTS nutritions_info;
CREATE TABLE nutritions_info (
	ingredients_id INT UNSIGNED NOT NULL,
    carbonhydrates FLOAT NOT NULL CHECK (carbonhydrates >= 0),
	lipids FLOAT NOT NULL CHECK (lipids >= 0),
	proteins FLOAT NOT NULL CHECK (proteins >= 0),
	PRIMARY KEY (carbonhydrates, lipids, proteins),
    CONSTRAINT fk_cooking_ingredients1
    FOREIGN KEY (ingredients_id)
    references cooking_ingredients(ingredients_id)
    ON UPDATE NO ACTION ON DELETE RESTRICT
);


#CREATE UNIQUE INDEX nutritions_info_pk ON nutritions_info (carbonhydrates, lipids, proteins);
#CREATE INDEX fk_cooking_ingredients1 ON nutritions_info(ingredients_id);

DROP TABLE IF EXISTS type_meal;
CREATE TABLE type_meal (
	type_meal_id INT UNSIGNED AUTO_INCREMENT NOT NULL,
    type_meal_name VARCHAR(100) NOT NULL,
    image varchar(100) not null check (image like 'https://%'),
    image_caption varchar(100) not null,
    PRIMARY KEY (type_meal_id)
);
#CREATE INDEX type_meal_pk ON  type_meal(type_meal_id);


DROP TABLE IF EXISTS ethnic;
CREATE TABLE ethnic (
    ethnic_id INT UNSIGNED NOT NULL,
    country_name VARCHAR(100) NOT NULL,
    image varchar(100) not null check (image like 'https://%'),
    image_caption varchar(100) not null,
    PRIMARY KEY(ethnic_id)
);
#CREATE unique INDEX  ethnic_pk ON ethnic(ethnic_id);

DROP TABLE IF EXISTS recipes;
CREATE TABLE recipes (
    recipe_id INT UNSIGNED AUTO_INCREMENT NOT NULL,
    cooking_or_pastry BOOL NOT NULL,
    difficulty INT NOT NULL CHECK (difficulty BETWEEN 1 AND 5),
    recipe_name VARCHAR(100) NOT NULL,
    recipe_description VARCHAR(500) NOT NULL,
    time_preparation INT UNSIGNED NOT NULL,
    time_execution INT UNSIGNED NOT NULL,
    total_time INT AS (time_preparation + time_execution) STORED,
    quantity INT UNSIGNED NOT NULL,
    ingredients_id INT UNSIGNED NOT NULL,
    ethnic_id INT UNSIGNED NOT NULL,
    image varchar(100) not null check (image like 'https://%'),
    image_caption varchar(40) not null,
    PRIMARY KEY (recipe_id,ethnic_id,ingredients_id),
    CONSTRAINT fk_ethnic FOREIGN KEY (ethnic_id) references ethnic(ethnic_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_cooking_ingredients FOREIGN KEY (ingredients_id) references cooking_ingredients(ingredients_id)
    ON UPDATE NO ACTION ON DELETE RESTRICT
);
#CREATE INDEX recipes_pk ON  recipes(recipe_id);
#CREATE INDEX fk_cooking_ingredients ON  recipes(ingredients_id);
#CREATE INDEX fk_ethnic ON  recipes(ethnic_id);





DROP TABLE IF EXISTS recipes_ingredients;
CREATE TABLE recipes_ingredients (
	ingredients_id INT UNSIGNED NOT NULL,
	recipe_id INT UNSIGNED NOT NULL,
	quantity FLOAT NOT NULL CHECK (quantity >= 0),
    primary key(ingredients_id,recipe_id),
    CONSTRAINT fk_recipes FOREIGN KEY (recipe_id) references recipes(recipe_id) ON UPDATE NO ACTION ON DELETE RESTRICT,
    CONSTRAINT fk_cooking_ingredients_recipes FOREIGN KEY (ingredients_id) references cooking_ingredients(ingredients_id) ON UPDATE NO ACTION ON DELETE RESTRICT
);

#CREATE INDEX fk_recipes ON  recipes_ingredients(recipe_id);
#CREATE INDEX fk_cooking_ingredients ON  recipes_ingredients(ingredients_id);


DROP TABLE IF EXISTS recipes_type_meal;
CREATE TABLE recipes_type_meal (
	recipe_id INT UNSIGNED NOT NULL,
    type_meal_id INT UNSIGNED NOT NULL,
    primary key(recipe_id,type_meal_id),
    CONSTRAINT fk_recipes_type_meal FOREIGN KEY (recipe_id) references recipes(recipe_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_recipes_type_meal2 FOREIGN KEY (type_meal_id) references type_meal(type_meal_id)
    ON UPDATE NO ACTION ON DELETE RESTRICT
);
#CREATE INDEX fk_recipes_type_meal ON  recipes_type_meal(type_meal_id);
#CREATE INDEX fk_recipes_type_meal2 ON  recipes_type_meal(recipe_id);



DROP TABLE IF EXISTS tips;
CREATE TABLE tips (
	type_meal_id INT UNSIGNED NOT NULL,
    tip VARCHAR(200) NOT NULL,
    PRIMARY KEY (tip,type_meal_id),
    CONSTRAINT fk_tips FOREIGN KEY (type_meal_id) references type_meal(type_meal_id)
    ON UPDATE NO ACTION ON DELETE RESTRICT
);
#CREATE INDEX tips_pk ON  tips(tip);
#CREATE INDEX fk_tips ON  tips(type_meal_id);


DROP TABLE IF EXISTS meal;
CREATE TABLE meal (
	meal_id INT UNSIGNED AUTO_INCREMENT NOT NULL,
    category_meal VARCHAR(100),
    image varchar(100) not null check (image like 'https://%'),
    image_caption varchar(100) not null,
    PRIMARY KEY (meal_id)
);
#CREATE INDEX meal_pk ON  meal(meal_id);

DROP TABLE IF EXISTS recipe_meals;
CREATE TABLE recipe_meals (
	meal_id INT UNSIGNED NOT NULL,
    recipe_id  INT UNSIGNED NOT NULL,
    primary key(meal_id,recipe_id),
    CONSTRAINT fk_recipe_meals FOREIGN KEY (meal_id) references meal(meal_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_recipe_meals2 FOREIGN KEY (recipe_id) references recipes(recipe_id)
    ON UPDATE NO ACTION ON DELETE RESTRICT
); 
#CREATE INDEX fk_recipe_meal ON  recipe_meals(meal_id);
#CREATE INDEX fk_recipe_meals2 ON  recipe_meals(recipe_id);

DROP TABLE IF EXISTS steps;
CREATE TABLE steps (
	steps_id INT UNSIGNED AUTO_INCREMENT NOT NULL,
    steps_str VARCHAR(200) NOT NULL,
    image varchar(100) not null check (image like 'https://%'),
    image_caption varchar(100) not null,
    PRIMARY KEY (steps_id)
);
    
DROP TABLE IF EXISTS steps_recipes;
CREATE TABLE steps_recipes (
	steps_id INT UNSIGNED NOT NULL,
    recipe_id INT UNSIGNED NOT NULL,
    step_counter INT UNSIGNED NOT NULL,
    primary key(steps_id,recipe_id),
    CONSTRAINT fk_steps_recipes FOREIGN KEY (steps_id) references steps(steps_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_steps_recipes2 FOREIGN KEY (recipe_id) references recipes(recipe_id)
    ON UPDATE NO ACTION ON DELETE RESTRICT
    );
#CREATE INDEX fk_steps_recipes ON  steps_recipes(steps_id);
#CREATE INDEX fk_steps_recipes2 ON  steps_recipes(recipe_id);


DROP TABLE IF EXISTS equipment;
CREATE TABLE equipment (
    equipment_id INT UNSIGNED AUTO_INCREMENT NOT NULL,
    equipment_name VARCHAR(40) NOT NULL,
    equipment_description VARCHAR(200) NOT NULL,
    image varchar(100) not null check (image like 'https://%'),
    image_caption varchar(40) not null,
    PRIMARY KEY (equipment_id)
);
#CREATE INDEX pk_equipment ON  equipment(equipment_id);



DROP TABLE IF EXISTS recipes_equipment;
CREATE TABLE recipes_equipment (
    equipment_id INT UNSIGNED NOT NULL,
    recipe_id INT UNSIGNED NOT NULL,
    primary key(recipe_id,equipment_id),
    CONSTRAINT fk_recipes_equipment FOREIGN KEY (recipe_id) references recipes(recipe_id)
    ON UPDATE NO ACTION ON DELETE RESTRICT,
    CONSTRAINT fk_recipes_equipment2 FOREIGN KEY (equipment_id) references equipment(equipment_id)
    ON UPDATE NO ACTION ON DELETE RESTRICT
);
#CREATE INDEX fk_recipes_equipment ON  recipes_equipment(recipe_id);
#CREATE INDEX fk_recipes_equipment2 ON  recipes_equipment(equipment_id);


-- DROP TABLE IF EXISTS equipment_steps;
-- CREATE TABLE equipment_steps (
 --   equipment_id INT UNSIGNED NOT NULL,
 --   steps_id INT UNSIGNED NOT NULL,
 --   CONSTRAINT fk_equipment_steps
 --   FOREIGN KEY (equipment_id)
 --   references equipment(equipment_id)
 --   ON UPDATE CASCADE ON DELETE RESTRICT,
 --   CONSTRAINT fk_equipment_steps2
 --   FOREIGN KEY (steps_id)
 --   references steps(steps_id)
 --   ON UPDATE CASCADE ON DELETE RESTRICT
-- );
#CREATE INDEX fk_equipment_steps ON  equipment_steps(equipment_id);
#CREATE INDEX fk_equipment_steps2 ON  equipment_steps(steps_id);




DROP TABLE IF EXISTS recipe_topics;
CREATE TABLE recipe_topics (
    topics_id INT UNSIGNED AUTO_INCREMENT NOT NULL,
    topics_name VARCHAR(100) NOT NULL,
    topics_description VARCHAR(200) NOT NULL,
    image varchar(100) not null check (image like 'https://%'),
    image_caption varchar(100) not null,
    PRIMARY KEY (topics_id) 
);
#CREATE unique INDEX  topics_pk ON recipe_topics(topics_id);


DROP TABLE IF EXISTS recipe_topics_recipes;
CREATE TABLE recipe_topics_recipes (
    topics_id INT UNSIGNED NOT NULL,
    recipe_id INT UNSIGNED NOT NULL,
    PRIMARY KEY(topics_id,recipe_id),
    CONSTRAINT fk_recipe_topics_recipes FOREIGN KEY (topics_id) references recipe_topics(topics_id)
    ON UPDATE NO ACTION ON DELETE RESTRICT,
    CONSTRAINT fk_recipe_topics_recipes2 FOREIGN KEY (recipe_id) references recipes(recipe_id)
    ON UPDATE NO ACTION ON DELETE RESTRICT
);
#CREATE INDEX  fk_recipe_topics_recipes ON recipe_topics_recipes(topics_id);
#CREATE INDEX  fk_recipe_topics_recipes2 ON recipe_topics_recipes(recipe_id);
 

DROP TABLE IF EXISTS cooker;
CREATE TABLE cooker (
    cooker_id INT UNSIGNED AUTO_INCREMENT NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    cooker_rank ENUM("C","B", "A","sous-chef","chef") NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone BIGINT NOT NULL CHECK (phone BETWEEN 6900000000 AND 6999999999),
    birth_date DATE NOT NULL CHECK (YEAR(birth_date) < 2005),
    years_of_experience INT UNSIGNED NOT NULL,
    CHECK (years_of_experience < 2024-15-YEAR(birth_date)),
    image varchar(100) not null check (image like 'https://%'),
    image_caption varchar(100) not null,
    PRIMARY KEY (cooker_id)
);
#CREATE UNIQUE INDEX  cooker_pk ON cooker(cooker_id);


DROP TABLE IF EXISTS cooker_ethnic;
CREATE TABLE cooker_ethnic (
    cooker_id INT UNSIGNED NOT NULL,
    ethnic_id INT UNSIGNED NOT NULL,
    primary key(cooker_id,ethnic_id),
    CONSTRAINT fk_cooker_ethnic FOREIGN KEY (cooker_id) references cooker(cooker_id)
    ON UPDATE NO ACTION ON DELETE RESTRICT,
    CONSTRAINT fk_cooker_ethnic2 FOREIGN KEY (ethnic_id) references ethnic(ethnic_id)
    ON UPDATE NO ACTION ON DELETE RESTRICT
);
#CREATE INDEX  fk_cooker_ethnic ON cooker_ethnic(cooker_id);
#CREATE INDEX  fk_cooker_ethnic2 ON cooker_ethnic(cooker_ethnic);

DROP TABLE IF EXISTS cooker_recipes;
CREATE TABLE cooker_recipes (
    cooker_id INT UNSIGNED NOT NULL,
    recipe_id INT UNSIGNED NOT NULL,
    primary key(cooker_id,recipe_id),
    CONSTRAINT fk_cooker_recipe1 FOREIGN KEY (cooker_id) references cooker(cooker_id)
    ON UPDATE NO ACTION ON DELETE RESTRICT,
    CONSTRAINT fk_cooker_recipe2 FOREIGN KEY (recipe_id) references recipes(recipe_id)
    ON UPDATE NO ACTION ON DELETE RESTRICT
);
#CREATE INDEX  fk_cooker_ethnic ON cooker_ethnic(cooker_id);
#CREATE INDEX  fk_cooker_ethnic2 ON cooker_ethnic(cooker_ethnic);

DROP TABLE IF EXISTS episode;
CREATE TABLE episode (
    episode_id INT UNSIGNED NOT NULL CHECK (episode_id BETWEEN 1 AND 10),
    season_year INT UNSIGNED NOT NULL CHECK (season_year BETWEEN 2022 AND 2024),
    PRIMARY KEY (episode_id, season_year)
);
#CREATE INDEX  episode_pk ON episode(episode_id,season_year);

DROP TABLE IF EXISTS episode_expansion;
CREATE TABLE episode_expansion (
    episode_id INT UNSIGNED NOT NULL,
    cooker_id INT UNSIGNED NOT NULL,
    recipe_id INT UNSIGNED NOT NULL,
    season_year INT UNSIGNED NOT NULL,
    is_judge BOOL NOT NULL,
    eval1 INT UNSIGNED CHECK (eval1 BETWEEN 1 AND 5),
    eval2 INT UNSIGNED CHECK (eval2 BETWEEN 1 AND 5),
    eval3 INT UNSIGNED CHECK (eval3 BETWEEN 1 AND 5),
    primary key(episode_id,season_year,cooker_id,recipe_id),
    CONSTRAINT fk_episode_expansion FOREIGN KEY (episode_id, season_year) references episode(episode_id, season_year)
    ON UPDATE NO ACTION ON DELETE RESTRICT,
    CONSTRAINT fk_episode_expansion2 FOREIGN KEY (cooker_id) references cooker(cooker_id)
    ON UPDATE NO ACTION ON DELETE RESTRICT,
    CONSTRAINT fk_episode_expansion3 FOREIGN KEY (recipe_id) references recipes(recipe_id)
    ON UPDATE NO ACTION ON DELETE RESTRICT
);
#CREATE INDEX  fk_episode_expansion ON episode_expansion(episode_id, season_year);
#CREATE INDEX  fk_episode_expansion2 ON episode_expansion(cooker_id);
#CREATE INDEX  fk_episode_expansion3 ON episode_expansion(recipe_id);





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

-- QUERY 14
SELECT topics_name, MAX(topic_count)
FROM (
    SELECT rtr.topics_id, COUNT(*) AS topic_count, rt.topics_name
    FROM episode_expansion AS ee
    INNER JOIN recipe_topics_recipes AS rtr ON ee.recipe_id = rtr.recipe_id
    INNER JOIN recipe_topics AS rt ON rt.topics_id = rtr.topics_id
    GROUP BY rtr.topics_id
) AS res;

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


SELECT SUM(a) AS sum_of_a, b, c
FROM your_table
GROUP BY b, c;
-----------------------------------

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
	
	;
-------------------------------------------------------------------------------------------------------------------------------------

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








