exports.up = function(knex) {
	return knex.schema.createTable("weather", function(weather) {
		weather.increments("id").primary();
		weather.string("name").notNullable();
		weather.string("description").notNullable();
		weather.integer("temp").notNullable();
		weather.integer("humidity").notNullable();
		weather.integer("pressure").notNullable();
		weather.integer("meal_id");
		weather
			.foreign("meal_id")
			.references("mealList.id")
			.onDelete("cascade");
	});
};

exports.down = function(knex) {
	return knex.schema.dropTableIfExists("weather");
};
