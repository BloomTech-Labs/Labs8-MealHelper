exports.up = function(knex, Promise) {
	return knex.schema.createTable("mealList", function(mealList) {
		mealList.increments();
		mealList
			.integer("recipe_id")
			.unsigned()
			.references("id")
			.inTable("recipe")
			.onDelete("cascade");
		mealList
			.integer("user_id")
			.unsigned()
			.references("id")
			.inTable("users")
			.onDelete("cascade");
		mealList.string("mealTime").notNullable();
		mealList.string("experience");
		mealList.string("date").notNullable();
	});
};

exports.down = function(knex, Promise) {
	return knex.schema.dropTableIfExists("mealList");
};
