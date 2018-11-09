exports.up = function(knex) {
	return knex.schema.createTable("ingredients", function(ingredients) {
		ingredients.increments("id").primary();
		ingredients.integer("ndb_id");
		ingredients.string("name", 51).notNullable();
		ingredients.string("nutrients_id");
		ingredients.foreign("user_id").references("users.id");
	});
};

exports.down = function(knex) {
	return knex.schema.dropTableIfExists("ingredients");
};
