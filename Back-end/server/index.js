const express = require("express");
const helmet = require("helmet");
const knex = require("knex");
const knexConfig = require("./knexfile");
const db = knex(knexConfig.development);
const server = express();
const port = 3300;
const bcrypt = require("bcrypt");

const cors = require("cors");

server.use(helmet());
server.use(cors());
server.use(express.json());

//Users Endpoints

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
			res.status(201).json(user);
		});
});

server.delete("/users/:id", (req, res) => {
	const { id } = req.params;
	db("users")
		.where({ id: id })
		.del()
		.then(deleted => {
			res.status(200).json(deleted);
		});
});

server.post("/login", (req, res) => {
	const { username, password, zip, healthCondition } = req.body;
	const user = { username, password, zip, healthCondition };
	console.log(user);
	db("users")
		.insert(user)
		.then(user => {
			res.status(201).json(user);
		});
});

server.listen(port, () => {
	console.log(`Server now listening on Port ${port}`);
});
