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
					nutrients_id: "23, 56, 12, 32",
					user_id: 1
				},
				{
					id: 2,
					ndb_id: 45,
					name: "Kraft Sliced Cheese",
					nutrients_id: "1, 22, 14, 102",
					user_id: 2
				},
				{
					id: 3,
					ndb_id: 1056,
					name: "Pringles Pizza Chips",
					nutrients_id: "12, 31, 44, 3",
					user_id: 3
				}
			]);
		});
};
