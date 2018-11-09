exports.up = function(knex) {
	return knex.schema.createTable("nutrients", function(nutrients) {
		nutrients.increments("id").primary();
		nutrients.string("name", 51).notNullable();
		//Explain unit convo to team
		nutrients.string("unit", 6).notNullable();
		nutrients.integer("value", 6).notNullable();
		nutrients.integer("nutrients_id").notNullable();
		nutrients.integer("user_id");
		nutrients.foreign("user_id").references("users.id");
	});
};

exports.down = function(knex) {
	return knex.schema.dropTableIfExists("nutrients");
};
