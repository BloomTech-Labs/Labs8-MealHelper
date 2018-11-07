exports.up = function(knex, Promise) {
	return Promise.all([
		knex.schema.createTable("users", function(users) {
			users.increments();
			users.string("email", 40).notNullable();
			users.string("password", 255).notNullable();
			users.integer("zip", 5);
			users.string("healthCondition", 20).notNullable();
		}),

		knex.schema.createTable("recipe", function(recipe) {
			recipe.increments();
			recipe.string("name", 51).notNullable();
			recipe.integer("calories", 6).notNullable();
			recipe.integer("servings", 3).notNullable();
			recipe
				.integer("ingredients_id")
				.references("id")
				.inTable("ingredients")
				.onDelete("cascade");
		}),

		knex.schema.createTable("ingredients", function(ingredients) {
			ingredients.increments();
			ingredients.integer("ndb_id").notNullable();
			ingredients.string("name", 51).notNullable();
			ingredients
				.integer("nutrients_id")
				.references("id")
				.inTable("nutrients")
				.onDelete("cascade");
		}),

		knex.schema.createTable("nutrients", function(nutrients) {
			nutrients.increments();
			nutrients.string("name", 51).notNullable();
			//Explain unit convo to team
			nutrients.string("unit", 6).notNullable();
			nutrients.integer("value", 6).notNullable();
			nutrients.integer("nutrients_id").notNullable();
		}),

		knex.schema.createTable("mealList", function(mealList) {
			mealList.increments();
			mealList
				.integer("recipe_id")
				.references("id")
				.inTable("recipe")
				.onDelete("cascade");
			mealList
				.integer("user_id")
				.references("id")
				.inTable("users")
				.onDelete("cascade");
			mealList.string("mealTime").notNullable();
			mealList.string("experience");
			mealList.string("date").notNullable();
		}),

		knex.schema.createTable("weather", function(weather) {
			weather.increments();
			weather.string("name").notNullable();
			weather.string("description").notNullable();
			weather.integer("temp").notNullable();
			weather.integer("humidity").notNullable();
			weather.integer("pressure").notNullable();
			weather
				.integer("mealId")
				.references("id")
				.inTable("mealList")
				.onDelete("cascade");
		}),

		knex.schema.createTable("alarms", function(alarms) {
			alarms.increments();
			alarms.integer("beginTime").notNullable();
			alarms.integer("endTime").notNullable();
			alarms.integer("beginLimit").notNullable();
			alarms.integer("endLimit").notNullable();
			alarms.integer("repeats").notNullable();
			alarms
				.integer("user_id")
				.references("id")
				.inTable("users")
				.onDelete("cascade");
		}),

		knex.schema.createTable("notes", function(notes) {
			notes.increments();
			notes.string("notebody");
			notes
				.integer("mealList_id")
				.references("id")
				.inTable("mealList")
				.onDelete("cascade");
		})
	]);
};

exports.down = function(knex, Promise) {
	return Promise.all([
		knex.schema.dropTableIfExists("users"),
		knex.schema.dropTableIfExists("recipe"),
		knex.schema.dropTableIfExists("ingredients"),
		knex.schema.dropTableIfExists("nutrients"),
		knex.schema.dropTableIfExists("mealList"),
		knex.schema.dropTableIfExists("weather"),
		knex.schema.dropTableIfExists("alarms"),
		knex.schema.dropTableIfExists("notes")
	]);
};
