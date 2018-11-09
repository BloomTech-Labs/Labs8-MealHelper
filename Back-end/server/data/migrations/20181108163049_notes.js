exports.up = function(knex) {
	return knex.schema.createTable("notes", function(notes) {
		notes.increments("id").primary();
		notes.string("notebody");
		notes.integer("meal_id");
		notes.foreign("meal_id").references("mealList.id");
	});
};

exports.down = function(knex) {
	return knex.schema.dropTableIfExists("notes");
};
