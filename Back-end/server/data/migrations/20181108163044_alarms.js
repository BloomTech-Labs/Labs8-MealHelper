exports.up = function(knex) {
	return knex.schema.createTable("alarms", function(alarms) {
		alarms.increments();
		alarms.integer("beginTime").notNullable();
		alarms.integer("endTime").notNullable();
		alarms.integer("beginLimit").notNullable();
		alarms.integer("endLimit").notNullable();
		alarms.integer("repeats").notNullable();
		alarms
			.integer("user_id")
			.unsigned()
			.references("id")
			.inTable("users")
			.onDelete("cascade");
	});
};

exports.down = function(knex) {
	return knex.schema.dropTableIfExists("alarms");
};
