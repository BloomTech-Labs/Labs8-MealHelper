exports.seed = function(knex, Promise) {
	// Deletes ALL existing entries
	return knex("users")
		.del()
		.then(function() {
			// Inserts seed entries
			return knex("users").insert([
				{
					id: 1,
					email: "imsilly@aol.com",
					password: "432425",
					zip: 95118,
					healthCondition: "lazyness"
				},
				{
					id: 2,
					email: "canttouchthis@gmail.com",
					password: "654321",
					zip: 11111,
					healthCondition: "alzheimers"
				},
				{
					id: 3,
					email: "Whatisthis@yahoo.com",
					password: "12345",
					zip: 43567,
					healthCondition: "sleepyness"
				}
			]);
		});
};
