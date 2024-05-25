USE cooking_contest_ntua;


-- TRIGGERS

DROP TRIGGER IF EXISTS check_tips_count;
DELIMITER // 
CREATE TRIGGER check_tips_count
BEFORE INSERT ON tips
FOR EACH ROW
BEGIN
    DECLARE tips_count INT;

    SELECT COUNT(*)
    INTO tips_count
    FROM tips
    WHERE type_meal_id = NEW.type_meal_id;

    IF tips_count >= 3 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Maximum of 3 tips allowed per meal';
    END IF;
END//
DELIMITER ;


DROP TRIGGER IF EXISTS check_step_count;
DELIMITER // 
CREATE TRIGGER check_step_count
BEFORE INSERT ON steps_recipes
FOR EACH ROW
BEGIN
    DECLARE c INT;

    SELECT count(*)
    INTO c
    FROM steps_recipes
    WHERE step_counter + 1 = NEW.step_counter AND recipe_id = NEW.recipe_id;

    IF NEW.step_counter <> 1 THEN
        IF c = 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'You have skipped a step';
        END IF;
    END IF;
END//
DELIMITER ;






-- VIEWS


drop VIEW recipe_food_group;

CREATE VIEW recipe_food_group
(recipe_name,recipe_id, food_group_name,food_group_id)
AS
SELECT
    r.recipe_name,
    r.recipe_id,
    f.food_group_name,
    f.food_group_id
FROM
    cooking_ingredients AS i
    INNER JOIN recipes AS r ON i.ingredients_id = r.ingredients_id
    INNER JOIN food_group AS f ON i.food_group_id = f.food_group_id;



create view co_re as 
(
select rr.recipe_id, rr.cooking_or_pastry, rr.recipe_name, rr.recipe_description, rr.time_preparation, rr.time_execution, rr.quantity, rr.ingredients_id, rr.ethnic_id, rr.image, rr.image_caption  
from cooker_recipes as cr inner join recipes as rr 
on cr.recipe_id = rr.recipe_id
);


create view my_cook as 
(
select *  
from cooker
where cooker_id = 1
);





-- Procedure

DROP PROCEDURE CKECK_IF_COMPETITION_IS_CORRECT;

#procedures
DELIMITER //
CREATE PROCEDURE CKECK_IF_COMPETITION_IS_CORRECT(in episode int, in season int, out flag bool)
BEGIN
	declare x int;
    declare y int;
    declare z int;
    declare e int;
    declare cr int;
    declare cee int;
    
    
    
	select count(cooker_id) into x
	from episode_expansion as ee
	where season_year = season and episod_id = episode
	group by cooker_id;
    
	select count(recipe_id) into y
	from episode_expansion as ee
	where season_year = season and episod_id = episode and is_judge = 0
    group by recipe_id;
    
    select count(eee.ethnic_id) into z
    from (select recipe_id
    from episode_expansion as ee
    where season_year = season and episod_id = episode and is_judge = 0) as eee inner join recipes as r on r.recipe_id = eee.recipe_id
    group by ethnic_id;
    
    select count(episode_id) into e
	from episode_expansion as ee
    where season_year = season;
    
    
    select count(*) into cr 
    from (
    select ee.cooker_id, ee.recipe_id
    from episode_expansion as ee
    where ee.season_year = season and ee.episod_id = episode and ee.is_judge = 0
    ) as ce inner join cooker_recipes as cr on (ce.cooker_id, ce.recipe_id) = (cr.cooker_id, cr.recipe_id);
    
    select count(*) into cee 
    from (
		select ce.cooker_id, r.ethinic_id
		from (
		select ee.cooker_id, ee.recipe_id
		from episode_expansion as ee
		where ee.season_year = season and ee.episod_id = episode and ee.is_judge = 0
		) as cr inner join recipes as r on r.recipe_id = cr.recipe_id
    ) as ce inner join cooker_ethnic as e on (ce.cooker_id, ce.recipe_id) = (e.cooker_id, e.recipe_id);


    if x <> 13 or y <> 10 or e <> 10 or z <> 10 or cee <> 10 or cr <> 10    then
		set flag = false;
    ELSE 
        SET flag = TRUE;
    END IF;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS DYNAMIC_CALORIES_CALULATOR;
#procedures
DELIMITER //
CREATE PROCEDURE DYNAMIC_CALORIES_CALULATOR(IN rec_id int ,OUT calories_overall FLOAT)
BEGIN
	
	select sum(total_calories_per_ingr) into calories_overall 
	from  (
			SELECT re.recipe_id as recipe_id, ci.ingredients_id as ingredients_id, (ni.carbonhydrates * 4 * ri.quantity / re.quantity) +
			(ni.lipids * 9 * ri.quantity / re.quantity) +
			(ni.proteins * 4 * ri.quantity / re.quantity) AS total_calories_per_ingr
			FROM nutritions_info AS ni inner join cooking_ingredients as ci ON ni.ingredients_id = ci.ingredients_id
			inner join recipes_ingredients as ri on ci.ingredients_id = ri.ingredients_id
			inner join recipes as re on re.recipe_id = ri.recipe_id
			) as calorie_subquery
	where recipe_id = rec_id
    group by recipe_id;
END //
DELIMITER ;





DROP PROCEDURE CHECK_AT_LEAST_ONE_STEP;
DELIMITER //

CREATE PROCEDURE CHECK_AT_LEAST_ONE_STEP(OUT flag BOOL)
BEGIN
    DECLARE cc INT;

    SELECT COUNT(*)
    INTO cc
    FROM recipes AS re
    LEFT JOIN steps_recipes AS sr
    ON re.recipe_id = sr.recipe_id
    WHERE sr.recipe_id IS NULL;

    IF cc > 0 THEN 
        SET flag = FALSE;
    ELSE 
        SET flag = TRUE;
    END IF;
END //

DELIMITER ;



DROP PROCEDURE CHECK_AT_LEAST_ONE_COOKER;
DELIMITER //

CREATE PROCEDURE CHECK_AT_LEAST_ONE_COOKER(OUT flag BOOL)
BEGIN
    DECLARE cc INT;

    SELECT COUNT(*)
    INTO cc
    FROM recipes AS re
    LEFT JOIN cooker_recipes AS cr
    ON re.recipe_id = cr.recipe_id
    WHERE cr.recipe_id IS NULL;

    IF cc > 0 THEN 
        SET flag = FALSE;
    ELSE 
        SET flag = TRUE;
    END IF;
END //

DELIMITER ;



-- Autharazition

create user 'admin'@'%' identified by 'admin';
grand all privileges on cooking_contest_ntua.* to 'admin'@'%';

flush privileges;

create user 'cooker1'@'%' identified by 'cooker1';
grand insert on recipes to 'cooker1'@'%';
grand all privileges on co_re to 'cooker1'@'%';
grand all privileges on my_cook to 'cooker1'@'%';

flush privileges;

