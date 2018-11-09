exports.up = function(knex, Promise) {
	return knex.schema.createTable("weather", function(weather) {
		weather.increments();
		weather.string("name").notNullable();
		weather.string("description").notNullable();
		weather.integer("temp").notNullable();
		weather.integer("humidity").notNullable();
		weather.integer("pressure").notNullable();
		weather
			.integer("mealId")
			.references("id")
			.inTable("mealList")
			.onDelete("cascade");
	});
};

exports.down = function(knex, Promise) {
	return knex.schema.dropTableIfExists("weather");
};
