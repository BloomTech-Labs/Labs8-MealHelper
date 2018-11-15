exports.seed = function(knex, Promise) {
	// Deletes ALL existing entries
	return knex("recipe")
		.del()
		.then(function() {
			// Inserts seed entries
			return knex("recipe").insert([
				{
					id: 1,
					name: "Pepperoni Pizza Slice",
					calories: 250,
					servings: 1,
					meal_id: 3
				},
				{
					id: 2,
					name: "Mac and Cheese",
					calories: 300,
					servings: 2,
					meal_id: 2
				},
				{
					id: 3,
					name: "Ham and Cheese Sandwhich",
					calories: 175,
					servings: 4,
					meal_id: 1
				}
			]);
		});
};
