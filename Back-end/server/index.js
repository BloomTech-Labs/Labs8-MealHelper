const express = require("express");
const helmet = require("helmet");
const knex = require("knex");
const jwt = require("jsonwebtoken");
const knexConfig = require("./knexfile");
const db = knex(knexConfig.development);
const server = express();
const port = 3300;
const bcrypt = require("bcrypt");

const cors = require("cors");

server.use(helmet());
server.use(cors());
server.use(express.json());

const jwtSecret = "thisisthesecretkeyplzdonttouch";

function generateToken(user) {
	const payload = {
		id: user.id,

		hello: "Hello!"
	};

	const JwtOptions = {
		expiresIn: "2h"
	};

	return jwt.sign(payload, jwtSecret, JwtOptions);
}
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//++++++++++++++++++++++++ USERS ENDPOINTS +++++++++++++++++++++++++++++++++++++++++++++++++
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

server.get("/users", (req, res) => {
	db("users").then(users => {
		res.status(200).json(users);
	});
});
//Register a new user
server.post("/register", (req, res) => {
	//Abstraction of req.body
	const { email, password, zip, healthCondition } = req.body;
	//Sets the user to a JSON object of what we pulled from req.body
	const user = { email, password, zip, healthCondition };
	//Hashing the password
	const hash = bcrypt.hashSync(user.password, 15);
	//Setting the password to our hash
	user.password = hash;
	db("users")
		.insert(user)
		.then(user => {
			//Registers the user and generates a jwt token for them
			const token = generateToken(user);
			res.status(201).json(user, { token: token });
		});
});
//Login a user
server.post("/login", (req, res) => {
	const { email, password } = req.body;
	const userLogin = { email, password };
	db("users")
		.where({ email: userLogin.email })
		.first()
		.then(user => {
			if (user && bcrypt.compareSync(userLogin.password, user.password)) {
				const token = generateToken(user);

				res
					.status(200)
					.json({ welcome: user.email, token: token, id: user.id });
			} else {
				res
					.status(500)
					.json({ error: "Wrong Email and/or Password, please try again" });
			}
		});
});

//PUT request to change the email or password
server.put("/users/:id", (req, res) => {
	const id = req.body.id;
	const credentials = req.body;
	console.log(credentials.password);
	db("users")
		//Finds the user by email
		.where({ email: credentials.email })
		.first()
		.then(user => {
			//Checking old password to verify it is correct
			if (user && bcrypt.compareSync(credentials.password, user.password)) {
				//Hashing the new password to be stored in DB (NOTE: its named newpassword not password)
				const hash = bcrypt.hashSync(credentials.newpassword, 15);
				//Sets the newpassword method to the hash to be stored
				credentials.newpassword = hash;
				db("users")
					.where({ id: id })
					.update({
						//Changing of the credentials
						email: credentials.email,
						//Sets the password of user to the hashed new password
						password: credentials.newpassword,
						zip: credentials.zip,
						healthCondition: credentials.healthCondition
					})
					.then(ids => {
						//Creates a token upon successfullying updating user
						const token = generateToken({ email: credentials.email });
						res.status(200).json({ token: token, id: id });
					})
					.catch(err => {
						console.log(err);
						res.status(500).json({ error: "Could not update User" });
					});
			} else {
				//Else statement goes off if the comparison if old password check does not match
				res
					.status(500)
					.json({ error: "Wrong Email and/or Password, please try again" });
			}
		});
});

//Delete a user
server.delete("/users/:id", (req, res) => {
	const { id } = req.params;
	db("users")
		.where({ id: id })
		.del()
		.then(deleted => {
			res.status(200).json(deleted);
		});
});

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//++++++++++++++++++++++++ MEAL LIST ENDPOINTS +++++++++++++++++++++++++++++++++++++++++++++++++
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//Returns a list of meals associated with a user id
server.get("/users/:userid/meals", (req, res) => {
	const userId = req.params.userid;
	db("mealList")
		//Finds the corrosponding meals based on user ID
		.where({ user_id: userId })
		.then(meal => {
			//Returns all the meals from that user
			res.status(200).json(meal);
		})
		.catch(err => {
			res.status(400).json({ error: "could not find meal" });
		});
});

server.post("/users/:userid/meals", (req, res) => {
	//grabs either the user id from req.params OR from the req.body (need to make choice later)
	const userId = req.params.userid;
	const { recipe_id, user_id, mealTime, experience, date } = req.body;
	//Grabs the associated data from req.body and sets it as a JSON to meal
	const meal = { recipe_id, user_id, mealTime, experience, date };
	console.log(meal);

	db("mealList")
		.insert(meal)
		.then(mealID => {
			//Returns the meal ID
			res.status(200).json(mealID);
		})
		.catch(err => {
			res.status(400).json({ error: "Error creating a new meal." });
		});
});
//PUT request to change the recipes, meal time, experience or experience
server.put("/meals/:mealID", (req, res) => {
	const id = req.params.mealID;
	const { recipe_id, user_id, mealTime, experience } = req.body;
	const meal = { recipe_id, user_id, mealTime, experience };
	db("mealList")
		.where({ id: id })
		.update({
			recipe_id: meal.recipe_id,
			mealTime: meal.mealTime,
			experience: meal.experience
		})
		.then(meal => {
			res.status(200).json(meal);
		})
		.catch(err => {
			res.status(400).json({ error: "Could not update meal" });
		});
});

//Deletes the meal using the meal id and returns 1 for deleted
server.delete("/users/:id/meals/:mealId", (req, res) => {
	const userID = req.params.id;
	const { mealId } = req.params;
	//Checks to make sure the id is an int
	if (userID === parseInt(userID, 10)) {
		db("mealList")
			.where({ id: mealId })
			.del()
			.then(deleted => {
				//Returns a 1 if deleted
				res.status(200).json(deleted);
			})
			.catch(err => {
				res.status(400).json({ error: "could not delete meals" });
			});
	} else {
		res.status(400).json({ error: "No user identified" });
	}
});
//Should Delete ALL meals associated with a user ID and return 1 for deleted
server.delete("/users/:id/meals/", (req, res) => {
	//Grabs the id from the API endpoint (front end job)
	const { id } = req.params;
	db("mealList")
		.where({ user_id: id })
		//Deletes the records
		.del()
		.then(deleted => {
			//Should return 1
			res.status(200).json(deleted);
		})
		.catch(err => {
			res.status(400).json({ error: "could not delete meals" });
		});
});

server.listen(port, () => {
	console.log(`Server now listening on Port ${port}`);
});
