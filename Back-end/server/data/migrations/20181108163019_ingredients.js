exports.up = function(knex, Promise) {
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
			.onDelete("cascade");
	});
};

exports.down = function(knex, Promise) {
	return knex.schema.dropTableIfExists("ingredients");
};
