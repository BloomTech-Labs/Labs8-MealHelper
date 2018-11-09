exports.up = function(knex) {
	return knex.schema.createTable("ingredients", function(ingredients) {
		ingredients.increments();
		ingredients.integer("ndb_id");
		ingredients.string("name", 51).notNullable();
		ingredients.string("nutrients_id");
		ingredients
			.integer("user_id")
			.unsigned()
			.references("id")
			.inTable("users")
			.onDelete("cascade")
			.notNullable();
	});
};

exports.down = function(knex) {
	return knex.schema.dropTableIfExists("ingredients");
};
