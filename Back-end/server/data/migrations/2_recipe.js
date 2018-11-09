exports.up = function(knex) {
	return knex.schema.createTable("recipe", function(recipe) {
		recipe.increments("id").primary();
		recipe.string("name", 51).notNullable();
		recipe.integer("calories", 6).notNullable();
		recipe.integer("servings", 3).notNullable();
		// mealList.integer("meal_id");
		// mealList.foreign("meal_id").references("mealList.id");
		recipe.integer("user_id");
		recipe
			.foreign("user_id")
			.references("users.id")
			.onDelete("cascade");

		recipe.string("ingredients_id");
	});
};

exports.down = function(knex) {
	return knex.schema.dropTableIfExists("recipe");
};
