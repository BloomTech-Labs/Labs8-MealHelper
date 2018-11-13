exports.seed = function(knex, Promise) {
	// Deletes ALL existing entries
	return knex("mealList")
		.del()
		.then(function() {
			// Inserts seed entries
			return knex("mealList").insert([
				{
					id: 1,

					user_id: 1,
					mealTime: "Snack",
					experience: "Sad",
					date: "07/06/2018"
				},
				{
					id: 2,

					user_id: 3,
					mealTime: "Lunch",
					experience: "Barf",
					date: "11/02/2018"
				},
				{
					id: 3,

					user_id: 2,
					mealTime: "Breakfast",
					experience: "Smily",
					date: "11/06/2018"
				}
			]);
		});
};
