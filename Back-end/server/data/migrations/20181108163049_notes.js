exports.up = function(knex) {
	return knex.schema.createTable("notes", function(notes) {
		notes.increments();
		notes.string("notebody");
		notes
			.integer("mealList_id")
			.unsigned()
			.references("id")
			.inTable("mealList")
			.onDelete("cascade");
	});
};

exports.down = function(knex) {
	return knex.schema.dropTableIfExists("notes");
};
