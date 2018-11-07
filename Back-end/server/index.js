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
	const { username, password, zip, healthCondition } = req.body;
	const user = { username, password, zip, healthCondition };
	const hash = bcrypt.hashSync(user.password, 15);
	console.log(hash);
	user.password = hash;
	console.log(user);
	db("users")
		.insert(user)
		.then(user => {
			const token = generateToken(user);
			res.status(201).json(user, { token: token });
		});
});
//Login a user
server.post("/login", (req, res) => {
	const { username, password } = req.body;
	const userLogin = { username, password };
	db("users")
		.where({ username: userLogin.username })
		.first()
		.then(user => {
			if (user && bcrypt.compareSync(userLogin.password, user.password)) {
				const token = generateToken(user);

				res
					.status(200)
					.header("Authorization", token)
					.json({ welcome: user.username, token: token, id: user.id });
			} else {
				res
					.status(500)
					.json({ error: "Wrong Username and/or Password, please try again" });
			}
		});
});

//PUT request to change the username or password
server.put("/users/:id", (req, res) => {
	const id = req.body.id;
	const credentials = req.body;
	console.log(credentials.password);
	db("users")
		.where({ username: credentials.username })
		.first()
		.then(user => {
			//Checking old password to verify it is correct
			if (user && bcrypt.compareSync(credentials.password, user.password)) {
				//Hashing the new password to be stored in DB
				const hash = bcrypt.hashSync(credentials.newpassword, 15);
				credentials.newpassword = hash;
				db("users")
					.where({ id: id })
					.update({
						//Changing of the credentials
						username: credentials.username,
						password: credentials.newpassword,
						zip: credentials.zip,
						healthCondition: credentials.healthCondition
					})
					.then(ids => {
						const token = generateToken({ username: credentials.username });
						res.status(200).json({ token: token, id: id });
					})
					.catch(err => {
						console.log(err);
						res.status(500).json({ error: "Could not update User" });
					});
			} else {
				res
					.status(500)
					.json({ error: "Wrong Username and/or Password, please try again" });
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
	console.log(req.params);
	const userId = req.params.userid;
	console.log(userId);
	db("mealList")
		.where({ user_id: userId })
		.then(meal => {
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
	const meal = { recipe_id, user_id, mealTime, experience, date };
	console.log(meal);

	db("mealList")
		.insert(meal)
		.then(meal => {
			res.status(200).json(meal);
		})
		.catch(err => {
			res.status(400).json({ error: "Error creating a new meal." });
		});
});

server.listen(port, () => {
	console.log(`Server now listening on Port ${port}`);
});
