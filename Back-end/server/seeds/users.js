exports.seed = function(knex, Promise) {
	// Deletes ALL existing entries
	return knex("users")
		.del()
		.then(function() {
			// Inserts seed entries
			return knex("users").insert([
				{
					id: 1,
					username: "Patrick",
					password: "432425",
					zip: 95118,
					healthCondition: "lazyness"
				},
				{
					id: 2,
					username: "Joseph",
					password: "654321",
					zip: 11111,
					healthCondition: "alzheimers"
				},
				{
					id: 3,
					username: "Casey",
					password: "12345",
					zip: 43567,
					healthCondition: "sleepyness"
				}
			]);
		});
};
