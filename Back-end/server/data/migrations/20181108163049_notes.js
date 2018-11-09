exports.up = function(knex) {
	return knex.schema.createTable("notes", function(notes) {
		notes.increments("id").primary();
		notes.string("notebody");
		notes.foreign("meal_id").references("mealList.id");
	});
};

exports.down = function(knex) {
	return knex.schema.dropTableIfExists("notes");
};
