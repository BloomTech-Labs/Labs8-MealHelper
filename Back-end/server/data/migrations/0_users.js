exports.up = function(knex) {
	return Promise.all([
		knex.schema.createTable("users", function(users) {
			users.increments("id").primary();
			users
				.string("email", 40)
				.unique()
				.notNullable();
			users.string("password", 255);
			users.integer("zip", 5);
			users.string("healthCondition", 20);
		}),
		knex.schema.createTable("mealList", function(mealList) {
			mealList.increments("id").primary();
			mealList.integer("user_id");
			mealList.foreign("user_id").references("users.id");
			mealList.string("mealTime").notNullable();
			mealList.string("experience");
			mealList.string("date").notNullable();
		}),
		knex.schema.createTable("recipe", function(recipe) {
			recipe.increments("id").primary();
			recipe.string("name", 51).notNullable();
			recipe.integer("calories", 6).notNullable();
			recipe.integer("servings", 3).notNullable();
			recipe.integer("meal_id");
			recipe.foreign("meal_id").references("mealList.id");
		}),
		knex.schema.createTable("ingredients", function(ingredients) {
			ingredients.increments("id").primary();
			ingredients.integer("ndb_id");
			ingredients.string("name", 51).notNullable();
			ingredients.string("nutrients_id");
			ingredients.integer("recipe_id");
			ingredients.foreign("recipe_id").references("recipe.id");
			ingredients.integer("user_id");
			ingredients.foreign("user_id").references("users.id");
		}),
		knex.schema.createTable("nutrients", function(nutrients) {
			nutrients.increments("id").primary();
			nutrients.string("name", 51).notNullable();
			//Explain unit convo to team
			nutrients.string("unit", 6).notNullable();
			nutrients.integer("value", 6).notNullable();
			nutrients.integer("nutrients_id").notNullable();
			nutrients.integer("ingredient_id");
			nutrients.foreign("ingredient_id").references("ingredients.id");
		}),
		knex.schema.createTable("weather", function(weather) {
			weather.increments("id").primary();
			weather.string("name").notNullable();
			weather.string("description").notNullable();
			weather.integer("temp").notNullable();
			weather.integer("humidity").notNullable();
			weather.integer("pressure").notNullable();
			weather.integer("meal_id");
			weather
				.foreign("meal_id")
				.references("mealList.id")
				.onDelete("cascade");
		}),
		knex.schema.createTable("alarms", function(alarms) {
			alarms.increments("id").primary();
			alarms.integer("beginTime").notNullable();
			alarms.integer("endTime").notNullable();
			alarms.integer("beginLimit").notNullable();
			alarms.integer("endLimit").notNullable();
			alarms.integer("repeats").notNullable();
			alarms.integer("user_id");
			alarms
				.foreign("user_id")
				.references("users.id")
				.onDelete("cascade");
		}),
		knex.schema.createTable("notes", function(notes) {
			notes.increments("id").primary();
			notes.string("notebody");
			notes.integer("meal_id");
			notes.foreign("meal_id").references("mealList.id");
		})
	]);
};

exports.down = function(knex) {
	return Promise.all([
		knex.schema.dropTableIfExists("users"),
		knex.schema.dropTableIfExists("mealList"),
		knex.schema.dropTableIfExists("recipe"),
		knex.schema.dropTableIfExists("ingredients"),
		knex.schema.dropTableIfExists("nutrients"),
		knex.schema.dropTableIfExists("weather"),
		knex.schema.dropTableIfExists("alarms"),
		knex.schema.dropTableIfExists("notes")
	]);
};
