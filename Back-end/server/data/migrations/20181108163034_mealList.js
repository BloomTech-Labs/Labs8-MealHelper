exports.up = function(knex) {
	return knex.schema.createTable("mealList", function(mealList) {
		mealList.increments("id").primary();
		mealList.foreign("recipe_id").references("recipe.id");

		mealList.foreign("user_id").references("users.id");

		mealList.string("mealTime").notNullable();
		mealList.string("experience");
		mealList.string("date").notNullable();
	});
};

exports.down = function(knex) {
	return knex.schema.dropTableIfExists("mealList");
};
