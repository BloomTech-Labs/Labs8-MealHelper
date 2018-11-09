exports.up = function(knex) {
	return knex.schema.createTable("alarms", function(alarms) {
		alarms.increments("id").primary();
		alarms.integer("beginTime").notNullable();
		alarms.integer("endTime").notNullable();
		alarms.integer("beginLimit").notNullable();
		alarms.integer("endLimit").notNullable();
		alarms.integer("repeats").notNullable();
		alarms
			.foreign("user_id")
			.references("users.id")
			.onDelete("cascade");
	});
};

exports.down = function(knex) {
	return knex.schema.dropTableIfExists("alarms");
};
