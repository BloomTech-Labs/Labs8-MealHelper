exports.seed = function(knex, Promise) {
	// Deletes ALL existing entries
	return knex("ingredients")
		.del()
		.then(function() {
			// Inserts seed entries
			return knex("ingredients").insert([
				{
					id: 1,
					ndb_id: 3456,
					name: "Cresco Beef Steak",
					recipe_id: 3,
					user_id: 1
				},
				{
					id: 2,
					ndb_id: 45,
					name: "Kraft Sliced Cheese",
					recipe_id: 2,
					user_id: 2
				},
				{
					id: 3,
					ndb_id: 1056,
					name: "Pringles Pizza Chips",
					recipe_id: 1,
					user_id: 3
				}
			]);
		});
};
