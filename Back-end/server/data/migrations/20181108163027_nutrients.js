exports.up = function(knex) {
	return knex.schema.createTable("nutrients", function(nutrients) {
		nutrients.increments();
		nutrients.string("name", 51).notNullable();
		//Explain unit convo to team
		nutrients.string("unit", 6).notNullable();
		nutrients.integer("value", 6).notNullable();
		nutrients.integer("nutrients_id").notNullable();
		nutrients
			.integer("user_id")
			.unsigned()
			.references("id")
			.inTable("users")
			.onDelete("cascade")
			.notNullable();
	});
};

exports.down = function(knex) {
	return knex.schema.dropTableIfExists("nutrients");
};
