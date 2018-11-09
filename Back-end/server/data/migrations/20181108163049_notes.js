exports.up = function(knex, Promise) {
	return knex.schema.createTable("notes", function(notes) {
		notes.increments();
		notes.string("notebody");
		notes
			.integer("mealList_id")
			.references("id")
			.inTable("mealList")
			.onDelete("cascade");
	});
};

exports.down = function(knex, Promise) {
	return knex.schema.dropTableIfExists("notes");
};
