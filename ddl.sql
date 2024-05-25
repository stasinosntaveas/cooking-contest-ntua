DROP SCHEMA if exists `cooking_contest_ntua`;
CREATE SCHEMA `cooking_contest_ntua`;
use cooking_contest_ntua;


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
    ON UPDATE NO ACTION ON DELETE RESTRICT,
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
CREATE INDEX fk_cooking_ingredients ON  recipes_ingredients(ingredients_id);


DROP TABLE IF EXISTS recipes_type_meal;
CREATE TABLE recipes_type_meal (
recipe_id INT UNSIGNED NOT NULL,
    type_meal_id INT UNSIGNED NOT NULL,
    primary key(recipe_id,type_meal_id),
    CONSTRAINT fk_recipes_type_meal FOREIGN KEY (recipe_id) references recipes(recipe_id)
    ON UPDATE NO ACTION ON DELETE RESTRICT,
    CONSTRAINT fk_recipes_type_meal2 FOREIGN KEY (type_meal_id) references type_meal(type_meal_id)
    ON UPDATE NO ACTION ON DELETE RESTRICT
);
#CREATE INDEX fk_recipes_type_meal ON  recipes_type_meal(type_meal_id);
CREATE INDEX fk_recipes_type_meal1 ON  recipes_type_meal(recipe_id);



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
CREATE INDEX fk_recipe_meal ON  recipe_meals(meal_id);
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
CREATE INDEX fk_steps_recipes ON  steps_recipes(steps_id);
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
CREATE INDEX fk_recipes_equipment ON  recipes_equipment(recipe_id);
#CREATE INDEX fk_recipes_equipment2 ON  recipes_equipment(equipment_id);


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
CREATE INDEX  fk_recipe_topics_recipes ON recipe_topics_recipes(topics_id);
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
CREATE INDEX  fk_cooker_ethnic ON cooker_ethnic(cooker_id);
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
CREATE INDEX  fk_cooker_ethnic ON cooker_ethnic(cooker_id);
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
    CONSTRAINT fk_episode_expansion1 FOREIGN KEY (episode_id, season_year) references episode(episode_id, season_year)
    ON UPDATE NO ACTION ON DELETE RESTRICT,
    CONSTRAINT fk_episode_expansion2 FOREIGN KEY (cooker_id) references cooker(cooker_id)
    ON UPDATE NO ACTION ON DELETE RESTRICT,
    CONSTRAINT fk_episode_expansion3 FOREIGN KEY (recipe_id) references recipes(recipe_id)
    ON UPDATE NO ACTION ON DELETE RESTRICT
);

CREATE INDEX  fk_episode_expansion1 ON episode_expansion(episode_id, season_year);
#CREATE INDEX  fk_episode_expansion2 ON episode_expansion(cooker_id);
#CREATE INDEX  fk_episode_expansion3 ON episode_expansion(recipe_id);

-- Indexies (from the queries)

CREATE INDEX  idx_episode_expansion1 ON episode_expansion(is_judge);
CREATE INDEX  idx_cooker ON cooker(birth_date);
CREATE INDEX  idx_ethnic ON ethnic(country_name);

