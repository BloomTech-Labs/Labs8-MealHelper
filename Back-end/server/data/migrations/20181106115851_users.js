exports.up = function(knex, Promise) {
	return knex.schema.createTable("users", function(users) {
		users.increments();
		users.string("email", 40).notNullable();
		users.string("password", 255).notNullable();
		users.integer("zip", 5);
		users.string("healthCondition", 20).notNullable();
	});
};

exports.down = function(knex, Promise) {
	return knex.schema.dropTableIfExists("users");
};
