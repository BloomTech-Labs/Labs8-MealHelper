exports.up = function(knex, Promise) {
	return knex.schema.createTable("nutrients", function(nutrients) {
		nutrients.increments();
		nutrients.string("name", 51).notNullable();
		//Explain unit convo to team
		nutrients.string("unit", 6).notNullable();
		nutrients.integer("value", 6).notNullable();
		nutrients.integer("nutrients_id").notNullable();
		nutrients
			.integer("user_id")
			.references("id")
			.inTable("users")
			.onDelete("cascade");
	});
};

exports.down = function(knex, Promise) {
	return knex.schema.dropTableIfExists("nutrients");
};
