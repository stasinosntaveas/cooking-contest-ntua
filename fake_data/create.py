import random
import faker
fake = faker.Faker()
import sys

N_RECIPES = 100
N_COOKERS = 100
N_EPISODES = 50
N_FOOD_GROUPS = 12
N_INGREDIENTS = 50
N_COUNTRIES = 40
N_TYPE_MEALS = 10
N_TOTAL_INGREDIENTS = 500
N_MEALS = 10
N_STEPS = 500
N_STEPS = max(N_STEPS, N_RECIPES)
N_EQUIPMENTS = 20
N_RECIPE_TOPICS = 10

random.seed(8)

recipes_with_main_ingredient = []
recipe_ethnic = [[] for _ in range(N_COUNTRIES+1)]
cooker_origin = [0 for _ in range(N_COOKERS+1)]
ethnic_cooker = [[] for _ in range(N_COUNTRIES+1)]
cooker_recipes = [[] for _ in range(N_COOKERS+1)]

def get_random_word(max_length):
	catch_phrase = fake.word()
	return catch_phrase if len(catch_phrase) <= max_length else catch_phrase[:max_length]
def get_random_catch_phrase(max_length):
    catch_phrase = fake.catch_phrase()
    return catch_phrase if len(catch_phrase) <= max_length else catch_phrase[:max_length]
def get_random_sentence(max_length):
    sentence = fake.sentence()
    return sentence if len(sentence) <= max_length else sentence[:max_length]
def get_random_paragraph(max_length):
    paragraph = fake.paragraph()
    # Trim the paragraph if it exceeds the maximum length
    return paragraph if len(paragraph) <= max_length else paragraph[:max_length]

# ------------------------------------------------------------------------------------------------------------------------------------------------- #
def fake_food_group(f):
    food_group_names = ["",
        "Spices and essential oils",
        "Coffee, tea and their products",
        "Preserved foods",
        "Sweeteners",
        "Fats and oils",
        "Milk, eggs and their products",
        "Meat and its products",
        "Fish and their products",
        "Cereals and their products",
        "Various foods of plant origin",
        "Products with sweeteners",
        "Various drinks"]
    food_group_descriptions = ["",
        "A wide range of aromatic substances derived from various parts of plants, used to flavor and enhance the taste of food dishes.",
        "Beverages and food items made from coffee beans and tea leaves, providing stimulating effects due to their caffeine content.",
        "Foods that have been processed and stored to prevent spoilage, including canned, pickled, dried, and frozen products.",
        "Substances used to add sweetness to foods and beverages, including sugar, honey, maple syrup, and artificial sweeteners.",
        "Lipid-rich substances derived from plants or animals, used for cooking, flavoring, and food preservation.",
        "Dairy and poultry products, including milk, cheese, yogurt, eggs, and various dairy-based desserts.",
        "Foods derived from animal flesh, including beef, pork, poultry, and processed meat products like sausages and deli meats.",
        "Foods derived from aquatic animals, including various types of fish, shellfish, and seafood products.",
        "Staple foods made from grains such as wheat, rice, corn, oats, barley, and rye, including bread, pasta, and breakfast cereals.",
        "Diverse plant-based foods, including fruits, vegetables, nuts, seeds, legumes, and plant-based meat substitutes.",
        "Food items that contain added sugars or artificial sweeteners to enhance their taste, including candies, pastries, and sugary beverages.",
        "A wide assortment of beverages, including water, juices, soft drinks, alcoholic beverages, and specialty drinks like smoothies and shakes."
    ]
    def build_food_group(food_group_id):
        food_group_name = food_group_names[food_group_id]
        food_group_description = food_group_descriptions[food_group_id]
        image = fake.image_url()
        image_caption = get_random_catch_phrase(40)
        return f"INSERT INTO food_group (food_group_id, food_group_name, food_group_description, image, image_caption) VALUES ('{
            food_group_id}', '{
            food_group_name}', '{
            food_group_description}', '{
            image}', '{
            image_caption}');\n"
    
    
    food_groups = (build_food_group(_) for _ in range(1, N_FOOD_GROUPS+1))
    
    for food_group in food_groups:
        f.write(food_group)
# ------------------------------------------------------------------------------------------------------------------------------------------------- #
def fake_cooking_ingredients(f):
    
    ingredients_names = ["",
    "Salt", "Sugar", "Flour", "Butter", "Eggs", "Milk", "Olive oil", "Garlic", "Onion", "Tomato",
    "Lemon", "Chicken", "Beef", "Fish", "Rice", "Pasta", "Cheese", "Yogurt", "Carrot", "Potato",
    "Spinach", "Broccoli", "Avocado", "Cucumber", "Bell pepper", "Mushroom", "Parsley", "Basil",
    "Cilantro", "Thyme", "Oregano", "Rosemary", "Chili powder", "Paprika", "Cumin", "Ginger",
    "Turmeric", "Honey", "Soy sauce", "Vinegar", "Mustard", "Worcestershire sauce", "Mayonnaise",
    "Ketchup", "Barbecue sauce", "Sriracha", "Tahini", "Maple syrup", "Vanilla extract", "Baking powder"
    ]
    measuring_units = ["",
        "teaspoon", "tablespoon", "cup", "fluid ounce", "pint", "quart", "gallon",
        "milliliter", "liter", "gram", "kilogram", "ounce", "pound"
    ]
    def make_ingredient_line(ingredient_id):
        ingredients_name = ingredients_names[ingredient_id]
        measuring_herd = random.choice(measuring_units)
        food_group_id = random.randint(1, N_FOOD_GROUPS)
        image = fake.image_url()
        image_caption = get_random_catch_phrase(40)
        return f"INSERT INTO cooking_ingredients (ingredients_id, ingredients_name, measuring_herd, food_group_id, image, image_caption) VALUES ('{
            ingredient_id}', '{
            ingredients_name}', '{
            measuring_herd}', '{
            food_group_id}', '{
            image}', '{
            image_caption}');\n"
    
    ingredients = (make_ingredient_line(_) for _ in range(1, N_INGREDIENTS+1))
    
    for ingredient in ingredients:
        f.write(ingredient)
# ------------------------------------------------------------------------------------------------------------------------------------------------- #
def fake_nutritions_info(f):
    def build_nutritions_info(ingredients_id):
        carbonhydrates = random.randint(0, 300) / 10
        lipids = random.randint(0, 300) / 10
        proteins = random.randint(0, 300) / 10
        return f"INSERT INTO nutritions_info (ingredients_id, carbonhydrates, lipids, proteins) VALUES ('{
            ingredients_id}','{
            carbonhydrates}', '{
            lipids}', '{
            proteins}');\n"
    
    nutritions_info = (build_nutritions_info(_) for _ in range(1, N_INGREDIENTS+1))
    
    for nutritions_info_line in nutritions_info:
        f.write(nutritions_info_line)
# ------------------------------------------------------------------------------------------------------------------------------------------------- #
def fake_type_meal(f):
    def build_type_meal(type_meal_id):
        type_meal_name = get_random_catch_phrase(40)
        image = fake.image_url()
        image_caption = get_random_catch_phrase(40)
        return f"INSERT INTO type_meal (type_meal_id, type_meal_name, image,image_caption) VALUES ('{
            type_meal_id}', '{
            type_meal_name}', '{
            image}', '{
            image_caption}');\n"
    
    type_meal_table = (build_type_meal(_) for _ in range(1, N_TYPE_MEALS+1))
    
    for type_meal in type_meal_table:
        f.write(type_meal)
# ------------------------------------------------------------------------------------------------------------------------------------------------- #
def fake_ethnic(f):
    def build_ethnic(ethnic_id):
        country_name = fake.country()
        image = fake.image_url()
        image_caption = get_random_catch_phrase(40)
        return f"INSERT INTO ethnic (ethnic_id, country_name, image,image_caption) VALUES ('{
            ethnic_id}', \"{
            country_name}\", '{
            image}', '{
            image_caption}');\n"

    etnic_table = (build_ethnic(_) for _ in range(1, N_COUNTRIES+1))

    for ethnic in etnic_table:
        f.write(ethnic)
# ------------------------------------------------------------------------------------------------------------------------------------------------- #
def fake_recipes(f):
    def build_recipe(recipe_id, ethnic_id = 0):
        cooking_or_pastry = random.choice([0, 1])
        difficulty = random.randint(1, 5)
        recipe_name = get_random_catch_phrase(100)
        recipe_description = get_random_paragraph(500)
        time_preparation = random.randint(0, 10) # in minutes
        time_execution = int(random.randint(30, 180)/5) * 5 # in minutes, only multiples of 5
        quantity = random.randint(2, 4)
        ingredients_id = random.randint(1, N_INGREDIENTS) # this is the main ingredient
        ethnic_id = random.randint(1, N_COUNTRIES) if ethnic_id == 0 else ethnic_id
        recipe_ethnic[ethnic_id].append(recipe_id)
        image = fake.image_url()
        image_caption = get_random_catch_phrase(40)
        recipes_with_main_ingredient.append((ingredients_id, recipe_id))
        return f"INSERT INTO recipes (recipe_id, cooking_or_pastry, difficulty, recipe_name, recipe_description, time_preparation, time_execution, quantity, ingredients_id, ethnic_id, image, image_caption) VALUES ('{
            recipe_id}', {
            cooking_or_pastry}, '{
            difficulty}', '{
            recipe_name}', '{
            recipe_description}', '{
            time_preparation}', '{
            time_execution}', '{
            quantity}', '{
            ingredients_id}', '{
            ethnic_id}', '{
            image}', '{
            image_caption}');\n"

    recipes = [build_recipe(_, _) for _ in range(1, N_COUNTRIES+1)]
    for _ in range(N_COUNTRIES+1, N_RECIPES+1):
        recipes.append(build_recipe(_))
    for recipe in recipes:
        f.write(recipe)
# ------------------------------------------------------------------------------------------------------------------------------------------------- #
def fake_recipes_ingredients(f):
    global recipes_with_main_ingredient
    def build_recipes_ingredients():
        ingredients_id = random.randint(1, N_INGREDIENTS)
        recipe_id = random.randint(1, N_RECIPES)
        return (ingredients_id, recipe_id)

    times = N_TOTAL_INGREDIENTS - len(recipes_with_main_ingredient)
    def create_pairs(x):
        p = 0
        while p < x:
            pair = build_recipes_ingredients()
            if pair in recipes_with_main_ingredient:
                p -= 1
            else:
                recipes_with_main_ingredient.append(pair)
            p += 1
    
    create_pairs(times)
    table = []
    for y in range(len(recipes_with_main_ingredient)):
        quantity = random.randint(1, 100)
        output = f"INSERT INTO recipes_ingredients (ingredients_id, recipe_id, quantity) VALUES ('{
            recipes_with_main_ingredient[y][0]}','{
            recipes_with_main_ingredient[y][1]}', '{
            quantity}');\n"
        table.append(output)
    for obj in table:
        f.write(obj)
# ------------------------------------------------------------------------------------------------------------------------------------------------- #
def fake_recipes_type_meal(f):
    l, table = [_ for _ in range(1, N_TYPE_MEALS+1)], []
    def build_rec(recipe_id):
        type_meal_ids = random.randint(1, N_TYPE_MEALS)
        type_meals = random.sample(l, type_meal_ids)
        for type_meal_id in type_meals:
            table.append(f"INSERT INTO recipes_type_meal (recipe_id, type_meal_id) VALUES ('{
                recipe_id+1}','{
                type_meal_id}');\n")

    for _ in range(N_RECIPES):
        build_rec(_)
    for obj in table:
        f.write(obj)
# ------------------------------------------------------------------------------------------------------------------------------------------------- #
def fake_tips(f):
    def build_tip(type_meal_id):
        # type_meal_id = random.randint(1, N_TYPE_MEALS)
        tip = get_random_sentence(200)
        return f"INSERT INTO tips (type_meal_id, tip) VALUES ('{
            type_meal_id+1}','{
            tip}');\n"
    
    table = (build_tip(_) for _ in range(N_TYPE_MEALS))
    
    for obj in table:
        f.write(obj)
# ------------------------------------------------------------------------------------------------------------------------------------------------- #
def fake_meal(f):
    def build_meal(meal_id):
        category_meal = get_random_word(40)
        image = fake.image_url()
        image_caption = get_random_catch_phrase(40)
        return f"INSERT INTO meal (meal_id, category_meal, image, image_caption) VALUES ('{
            meal_id+1}', '{
            category_meal}', '{
            image}', '{
            image_caption}');\n"
    
    table = (build_meal(_) for _ in range(N_MEALS))
    for obj in table:
        f.write(obj)
# ------------------------------------------------------------------------------------------------------------------------------------------------- #
def fake_recipe_meals(f):
    l = list(range(1, N_MEALS + 1))
    def build_first_recipe_meal(recipe_id):
        length = random.randint(1, N_MEALS)
        _ = random.sample(l, length)
        for i in _:
            y = f"INSERT INTO recipe_meals (meal_id, recipe_id) VALUES ('{
            i}','{
            recipe_id+1}');\n"
            f.write(y)
    
    for _ in range(N_RECIPES):
        build_first_recipe_meal(_)
# ------------------------------------------------------------------------------------------------------------------------------------------------- #
def fake_steps(f):
    def build_step(steps_id):
        steps_str = get_random_sentence(200)
        image = fake.image_url()
        image_caption = get_random_catch_phrase(40)
        return f"INSERT INTO steps (steps_id, steps_str, image, image_caption) VALUES ('{
            steps_id+1}', '{
            steps_str}', '{
            image}', '{
            image_caption}');\n"
    
    table = (build_step(_) for _ in range(N_STEPS))
    for _ in table:
        f.write(_)
# ------------------------------------------------------------------------------------------------------------------------------------------------- #
def fake_steps_recipes(f):
    table = []
    steps_counter = [2 for _ in range(N_RECIPES)]
    for _ in range(N_RECIPES):
        table.append((_+1, _+1, 1))

    for _ in range(N_RECIPES, N_STEPS):
        recipe_id = random.randint(1, N_RECIPES)
        table.append((_, recipe_id, steps_counter[recipe_id-1]))
        steps_counter[recipe_id-1] += 1

    for _ in range(len(table)):
        table[_] = f"INSERT INTO steps_recipes (steps_id, recipe_id, step_counter) VALUES ('{
            table[_][0]}', '{
            table[_][1]}', '{
            table[_][2]}');\n"
        
    for _ in table:
        f.write(_)
# ------------------------------------------------------------------------------------------------------------------------------------------------- #
def fake_equipment(f):
    def build_equipment(equipment_id):
        equipment_name = get_random_word(40)
        equipment_description = get_random_sentence(200)
        image = fake.image_url()
        image_caption = get_random_catch_phrase(40)
        return f"INSERT INTO equipment (equipment_id, equipment_name, equipment_description, image, image_caption) VALUES ('{
            equipment_id+1}', '{
            equipment_name}', '{
            equipment_description}', '{
            image}', '{
            image_caption}');\n"
    
    table = []
    for _ in range(N_EQUIPMENTS):
        table.append(build_equipment(_))

    for _ in table:
        f.write(_)
# ------------------------------------------------------------------------------------------------------------------------------------------------- #
def fake_recipes_equipment(f):
    def build_recipes_equipment(equipment_id, recipe_id):
        return f"INSERT INTO recipes_equipment (equipment_id, recipe_id) VALUES ('{
            equipment_id}', '{
            recipe_id}');\n"
    l, table = [_ for _ in range(1, N_EQUIPMENTS+1)], []

    def build_recipes_equipment_for_recipe_i(recipe_id):
        equipment_pieces_number = random.randint(1, N_EQUIPMENTS)
        equipment_piece = random.sample(l, equipment_pieces_number)
        for _ in equipment_piece:
            table.append(build_recipes_equipment(_, recipe_id))
        
    for _ in range(N_RECIPES):
        build_recipes_equipment_for_recipe_i(_+1)

    for _ in table:
        f.write(_)
# ------------------------------------------------------------------------------------------------------------------------------------------------- #
def fake_equipment_steps(f):
    def build_equipment_steps(steps_id):
        equipment_id = random.randint(1, N_EQUIPMENTS)
        return f"INSERT INTO equipment_steps (equipment_id, steps_id) VALUES ('{
            equipment_id}', '{
            steps_id+1}');\n"
    
    table = [build_equipment_steps(_) for _ in range(N_STEPS)]
    for obj in table:
        f.write(obj)
# ------------------------------------------------------------------------------------------------------------------------------------------------- #
def fake_recipe_topics(f):
    def build_recipe_topics(topics_id):
        topics_name = get_random_word(100)
        topics_description = get_random_catch_phrase(40)
        image = fake.image_url()
        image_description = get_random_catch_phrase(40)
        return f"INSERT INTO recipe_topics (topics_id, topics_name, topics_description, image, image_caption) VALUES ('{
            topics_id+1}', '{
            topics_name}', '{
            topics_description}', '{
            image}', '{
            image_description}');\n"
    
    table = [build_recipe_topics(_) for _ in range(N_RECIPE_TOPICS)]

    for obj in table:
        f.write(obj)
# ------------------------------------------------------------------------------------------------------------------------------------------------- #
def fake_recipe_topics_recipes(f):
    topics_ids, table = [_ for _ in range(1, N_RECIPE_TOPICS+1)], []

    def build_recipe_topics_recipes(recipe_id):
        total_topics = random.randint(1, N_RECIPE_TOPICS)
        topics = random.sample(topics_ids, total_topics)
        for topics_id in topics:
            table.append(f"INSERT INTO recipe_topics_recipes (topics_id, recipe_id) VALUES ('{
            topics_id}', '{
            recipe_id}');\n")

    for _ in range(1, N_RECIPES+1):
        build_recipe_topics_recipes(_)

    for obj in table:
        f.write(obj)
# ------------------------------------------------------------------------------------------------------------------------------------------------- #
def fake_cooker(f):
    # cooker_ranks = ["Γ' μάγειρας","Β' μάγειρας", "Α' μάγειρας","βοηθός Αρχιμάγειρα","Αρχιμάγειρας(σέφ)"]
    cooker_ranks = ["C", "B", "A", "sous-chef", "chef"]
    def _8_random_digits():
        return random.randint(900000000, 999999999)
    def build_cooker(cooker_id):
        first_name = fake.first_name()
        cooker_rank = random.choice(cooker_ranks)
        last_name = fake.last_name()
        phone_number = f"6{_8_random_digits()}"
        month = random.randint(1, 12)
        if month < 10:
            month = f"0{month}"
        date = random.randint(1, 28)
        if date < 10:
            date = f"0{date}"
        year = random.randint(1960, 2000)
        birth_date = f"{year}-{month}-{date}"
        years_of_experience = random.randint(0, 2020 - year - 15)
        image = fake.image_url()
        image_caption = get_random_catch_phrase(40)
        return f"INSERT INTO cooker (cooker_id, first_name, cooker_rank, last_name, phone, birth_date, years_of_experience, image, image_caption) VALUES ('{
            cooker_id+1}', '{
            first_name}', '{
            cooker_rank}', '{
            last_name}', '{
            phone_number}', '{
            birth_date}', '{
            years_of_experience}', '{
            image}', '{
            image_caption}');\n"

    table = [build_cooker(_) for _ in range(N_COOKERS)]
   
    for obj in table:
        f.write(obj)
# ------------------------------------------------------------------------------------------------------------------------------------------------- #
def fake_cooker_ethnic(f):
    def build_cooker_ethnic(cooker_id, ethnic_id = 0):
        ethnic_id = random.randint(1, N_COUNTRIES) if ethnic_id == 0 else ethnic_id
        cooker_origin[cooker_id] = ethnic_id
        ethnic_cooker[ethnic_id].append(cooker_id)
        return f"INSERT INTO cooker_ethnic (cooker_id, ethnic_id) VALUES ('{
            cooker_id}', '{
            ethnic_id}');\n"
    
    table = [build_cooker_ethnic(_, _) for _ in range(1, N_COUNTRIES+1)]
    for _ in range(N_COUNTRIES+1, N_COOKERS+1):
        table.append(build_cooker_ethnic(_))
   
    for obj in table:
        f.write(obj)
# ------------------------------------------------------------------------------------------------------------------------------------------------- #
def fake_cooker_recipes(f):
    table = []

    def build_cooker_recipes(cooker_id):
        country = cooker_origin[cooker_id]
        number_of_recipes = random.randint(1, len(recipe_ethnic[country]))
        recipes = random.sample(recipe_ethnic[country], number_of_recipes)
        for recipe in recipes:
            cooker_recipes[cooker_id].append(recipe)
            table.append(f"INSERT INTO cooker_recipes (cooker_id, recipe_id) VALUES ('{
                cooker_id}', '{
                recipe}');\n")
        
    for _ in range(1, N_COOKERS+1):
        build_cooker_recipes(_)
   
    for obj in table:
        f.write(obj)
# ------------------------------------------------------------------------------------------------------------------------------------------------- #
def fake_episode(f):
    def build_episode(episode_id, season_year):
        return f"INSERT INTO episode (episode_id, season_year) VALUES ('{
            episode_id}', '{
            season_year}');\n"
    
    table = []

    for season in range(2022, 2025):
        for episode in range(1, 11):
            table.append(build_episode(episode, season))

    for obj in table:
        f.write(obj)
# ------------------------------------------------------------------------------------------------------------------------------------------------- #
def fake_episode_expansion(f):
    table, countries, cooks = [], [_ for _ in range(1, N_COUNTRIES+1)], [_ for _ in range(1, N_COOKERS+1)]

    def build_episode_expansion(episode_id, season_year, this = [], that = [], these = [], those = []):
        if episode_id < 10:
            cuisine = random.sample(countries, 33)
            for _ in cuisine:
                if _ in this and _ in that:
                    cuisine.remove(_)
            cuisine = cuisine[:13]
            cookers = []
            for _ in cuisine:
                cooker = random.choice(ethnic_cooker[_])
                cookers.append(cooker)

            # now cuisine consists of 10 countries that follow the rules,
            # coookers consists of 10 cookers that follow the rules,
            # judges consists of 3 cookers that follow the rules

            recipe_id = [random.choice(cooker_recipes[_]) for _ in cookers]
            for _ in range(3):
                table.append(f"INSERT INTO episode_expansion (episode_id, cooker_id, recipe_id, season_year, is_judge, eval{_+1}) VALUES ('{
                episode_id}', '{
                cookers[_]}', '{
                recipe_id[_]}', '{
                season_year}', 1, '1');\n")

            for _ in range(3, 13):
                table.append(f"INSERT INTO episode_expansion (episode_id, cooker_id, recipe_id, season_year, is_judge, eval1, eval2, eval3) VALUES ('{
                episode_id}', '{
                cookers[_]}', '{
                recipe_id[_]}', '{
                season_year}', 0, '{
                random.randint(1, 5)}','{
                random.randint(1, 5)}','{
                random.randint(1, 5)}');\n")

            cuisine = cuisine[3:]
            cookers = cookers[3:]
            build_episode_expansion(episode_id+1, season_year, cuisine, this, cookers, these)

    for season in range(2022, 2024+1):
        build_episode_expansion(1, season, [], [])

    for obj in table:
        f.write(obj)
    

s = f"INSERT INTO episode_expansion (episode_id, cooker_id, recipe_id, season_year, is_judge, eval1, eval2, eval3) VALUES ('"
with open("fake_data.sql", "w") as f:
    f.write("BEGIN;\n\n")
    fake_food_group(f)
    f.write("\n")
    fake_cooking_ingredients(f)
    f.write("\n")
    fake_nutritions_info(f)
    f.write("\n")
    fake_type_meal(f)
    f.write("\n")
    fake_ethnic(f)
    f.write("\n")
    fake_recipes(f)
    f.write("\n")
    fake_recipes_ingredients(f)
    f.write("\n")
    fake_recipes_type_meal(f)
    f.write("\n")
    fake_tips(f)
    f.write("\n")
    fake_meal(f)
    f.write("\n")
    fake_recipe_meals(f)
    f.write("\n")
    fake_steps(f)
    f.write("\n")
    fake_steps_recipes(f)
    f.write("\n")
    fake_equipment(f)
    f.write("\n")
    fake_recipes_equipment(f)
    f.write("\n")
    fake_recipe_topics(f)
    f.write("\n")
    fake_recipe_topics_recipes(f)
    f.write("\n")
    fake_cooker(f)
    f.write("\n")
    fake_cooker_ethnic(f)
    f.write("\n")
    fake_cooker_recipes(f)
    f.write("\n")
    fake_episode(f)
    f.write("\n")
    fake_episode_expansion(f)
    f.write("\n")
    f.write("\nCOMMIT;\n")
