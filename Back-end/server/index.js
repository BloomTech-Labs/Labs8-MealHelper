const express = require("express");
const helmet = require("helmet");
const knex = require("knex");
const jwt = require("jsonwebtoken");

const dbEngine = process.env.DB || "production";
const knexConfig = require("./knexfile.js")[dbEngine];

const db = knex(knexConfig);
const server = express();

const port = process.env.PORT || 3300;
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

/////////ROUTE IMPORTS///////////////
// const userRoutes = require("./users/usersRoutes");

// server.use("/users", userRoutes);

server.get("/", (req, res) => {
	res.status(200).json({ Welcome: " Welcome !" });
});

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//++++++++++++++++++++++++ USERS ENDPOINTS +++++++++++++++++++++++++++++++++++++++++++++++++
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
server.get("/users", (req, res) => {
	db("users")
		.then(users => {
			res.status(200).json(users);
		})
		.catch(err => {
			res.status(400).json({ error: "could not grab users" });
		});
});
// Register a new user
server.post("/register", (req, res) => {
	//Abstraction of req.body
	const { email, password, zip, healthCondition } = req.body;
	console.log(req.body);
	//Sets the user to a JSON object of what we pulled from req.body
	const user = { email, password, zip, healthCondition };
	//Hashing the password

	const hash = bcrypt.hashSync(user.password, 15);
	//Setting the password to our hash
	user.password = hash;
	console.log(user);
	db("users")
		.insert(user)
		.then(userReturn => {
			const token = generateToken(user);
			console.log(user);
			db("users")
				.where({ email: user.email })
				.first()
				.then(user => {
					console.log(user);
					res.status(200).json({ userID: user.id, token: token });
				})
				.catch(err => {
					res.status(400).json({ error: "could not grab user" });
				});
		})
		.catch(err => {
			res.status(400).json({ msg: err, error: "Could not create a user" });
		});
});
//Registers and checks auth0
server.post("/registerAuth0", (req, res) => {
	//Abstraction of req.body
	console.log(req.body);
	const { email } = req.body;
	console.log(req.body);
	//Sets the user to a JSON object of what we pulled from req.body
	const user = { email };
	//Hashing the password
	console.log(user);
	db("users")
		.insert(user)
		.then(userMsg => {
			const token = generateToken(user);
			res.status(201).json({ userID: userMsg, token: token });
		})
		.catch(err => {
			db("users")
				.where({ email: user.email })
				.first()
				.then(user => {
					const token = generateToken(user);

					res.status(200).json({ userID: user, token: token });
				})
				.catch(err => {
					res.status(500).json({
						error: "Wrong Email and/or Password, please try again"
					});
				});
		});
});

// Login a user
server.post("/login", (req, res) => {
	const { email, password } = req.body;
	const userLogin = { email, password };
	db("users")
		.where({ email: userLogin.email })
		.first()
		.then(user => {
			if (user && bcrypt.compareSync(userLogin.password, user.password)) {
				const token = generateToken(user);

				res.status(200).json({ userID: user.id, token: token });
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
						const token = generateToken(credentials);
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
	const { user_id, mealTime, experience, date } = req.body;
	//Grabs the associated data from req.body and sets it as a JSON to meal
	const meal = { user_id, mealTime, experience, date };
	console.log(meal);

	db("mealList")
		.insert(meal)
		.then(mealID => {
			//Returns the meal ID
			res.status(200).json(mealID);
		})
		.catch(err => {
			res.status(400).json({ msg: err, error: "Error creating a new meal." });
		});
});
//PUT request to change the recipes, meal time, experience or experience
server.put("/meals/:mealID", (req, res) => {
	const id = req.params.mealID;
	const { user_id, mealTime, experience } = req.body;
	const meal = { user_id, mealTime, experience };
	db("mealList")
		.where({ id: id })
		.update({
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

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//++++++++++++++++++++++++ RECIPE ENDPOINTS +++++++++++++++++++++++++++++++++++++++++++++++++
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//GET requst to get all recipes (DEVELOPER TESTING ONLY)
server.get("/recipe", (req, res) => {
	db("recipe")
		.then(recipes => {
			//Returns all the recipes
			res.status(200).json(recipes);
		})
		.catch(err => {
			res.status(400).json({ err, error: "could not find recipes" });
		});
});
//GET request to grab all recipes made by a specific user
server.get("/recipe/:userid", (req, res) => {
	const userId = req.params.userid;
	db("recipe")
		//Finds the corrosponding recipes based on user ID
		.where({ user_id: userId })
		.then(meal => {
			//Returns all the recipes from that user
			res.status(200).json(meal);
		})
		.catch(err => {
			res.status(400).json({ err, error: "could not find meal" });
		});
});
//POST request to create a recipe
server.post("/recipe/:userid", (req, res) => {
	//grabs the user id from the req.params
	const user_id = req.params.userid;
	const { meal_id, name, calories, servings, ingredients_id } = req.body;
	//Grabs the associated data from req.body and sets it as a JSON to recipe
	//NOTE: ingredients_id is a string of ids, needs to be de stringified on front end
	const recipe = { meal_id, name, user_id, calories, servings, ingredients_id };
	console.log(recipe);

	db("recipe")
		.insert(recipe)
		.then(recipeID => {
			//Returns the meal ID
			res.status(200).json(recipeID);
		})
		.catch(err => {
			res.status(400).json({ err, error: "Error creating a new meal." });
		});
});

//PUT request to change the recipes, meal time, experience or experience
server.put("/recipe/:id", (req, res) => {
	//Grabs recipe ID from req.params
	const id = req.params.id;
	const { name, calories, servings, ingredients_id } = req.body;
	//Grabs the associated data from req.body and sets it as a JSON to recipe
	//NOTE: ingredients_id is a string of ids, needs to be de stringified on front end
	const recipe = { name, calories, servings, ingredients_id };
	db("recipe")
		.where({ id: id })
		.update({
			//UPDATES the name, calories etc of the recipe if needed.
			name: recipe.name,
			calories: recipe.calories,
			servings: recipe.servings,
			ingredients_id: recipe.ingredients_id
		})
		.then(meal => {
			//Returns the ID of the meal changed
			res.status(200).json(meal);
		})
		.catch(err => {
			res.status(400).json({ error: "Could not update meal" });
		});
});

//DELETE a recipe
server.delete("/recipe/:id", (req, res) => {
	//Grabs the id from the API endpoint (front end job)
	const { id } = req.params;
	db("recipe")
		.where({ id: id })
		//Deletes the records
		.del()
		.then(deleted => {
			//Should return 1 if deleted, returns 0 if not
			res.status(200).json(deleted);
		})
		.catch(err => {
			res.status(400).json({ error: "could not delete meals" });
		});
});
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//++++++++++++++++++++++++ INGREDIENTS ENDPOINTS +++++++++++++++++++++++++++++++++++++++++++++++++
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//GET requst to get all INGREDIENTS (DEVELOPER TESTING ONLY)
server.get("/ingredients", (req, res) => {
	db("ingredients")
		.then(ingredients => {
			//Returns all the ingredients
			res.status(200).json(ingredients);
		})
		.catch(err => {
			res.status(400).json({ err, error: "could not find recipes" });
		});
});
//GET request to grab all ingredients made by a specific user
server.get("/ingredients/:userid", (req, res) => {
	const userId = req.params.userid;
	db("ingredients")
		//Finds the corrosponding ingredients based on user ID
		.where({ user_id: userId })
		.then(ingredients => {
			//Returns all the recipes from that user
			res.status(200).json(ingredients);
		})
		.catch(err => {
			res.status(400).json({ err, error: "could not find meal" });
		});
});

//POST request to create an ingredients
server.post("/ingredients/:userid", (req, res) => {
	//grabs the user id from the req.params
	const user_id = req.params.userid;
	const { name, nutrients_id } = req.body;
	//Grabs the associated data from req.body and sets it as a JSON to recipe
	//NOTE: ingredients_id is a string of ids, needs to be de stringified on front end
	const ingredient = { name, nutrients_id, user_id };

	db("ingredients")
		.insert(ingredient)
		.then(ingredientID => {
			//Returns the ingredients ID
			res.status(200).json(ingredientID);
		})
		.catch(err => {
			res.status(400).json({ err, error: "Error creating a new meal." });
		});
});

//PUT request to change the ingredient
server.put("/ingredients/:id", (req, res) => {
	//Grabs recipe ID from req.params
	const id = req.params.id;
	const { ndb_id, name, nutrients_id } = req.body;
	//Grabs the associated data from req.body and sets it as a JSON to recipe
	//NOTE: ingredients_id is a string of ids, needs to be de stringified on front end
	const ingredient = { ndb_id, name, nutrients_id, user_id };
	db("ingredients")
		.where({ id: id })
		.update({
			//UPDATES the name, calories etc of the recipe if needed.
			ndb_id: ingredient.ndb_id,
			name: ingredient.name,
			nutrients_id: ingredient.nutrients_id
		})
		.then(ingredientID => {
			//Returns the ID of the meal changed
			res.status(200).json(ingredientID);
		})
		.catch(err => {
			res.status(400).json({ error: "Could not update meal" });
		});
});

//DELETE a recipe
server.delete("/ingredients/:id", (req, res) => {
	//Grabs the id from the API endpoint (front end job)
	const { id } = req.params;
	db("ingredients")
		.where({ id: id })
		//Deletes the records
		.del()
		.then(deleted => {
			//Should return 1 if deleted, returns 0 if not
			res.status(200).json(deleted);
		})
		.catch(err => {
			res.status(400).json({ error: "could not delete meals" });
		});
});
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//++++++++++++++++++++++++ NUTRIENTS ENDPOINTS +++++++++++++++++++++++++++++++++++++++++++++++++
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//GET requst to get all nutrients (DEVELOPER TESTING ONLY)
server.get("/nutrients", (req, res) => {
	db("nutrients")
		.then(nutrients => {
			//Returns all the nutrients
			res.status(200).json(nutrients);
		})
		.catch(err => {
			res.status(400).json({ err, error: "could not find nutrients" });
		});
});
//GET request to grab all nutrients for a specific ingredient
server.get("/nutrients/:ingredientID", (req, res) => {
	const ingredientId = req.params.ingredientID;
	db("ingredients")
		//Finds the corrosponding nutrients based on ingredient ID
		.where({ id: ingredientId })
		//Doing a where request returns an array, so we want the first index of that array.
		.first()
		.then(ingredients => {
			db("nutrients")
				.where({ ingredient_id: ingredientId })
				.then(nutrients => {
					//Returns all the nutrients
					res.status(200).json(nutrients);
				})
				.catch(err => {
					res.status(400).json({ err, error: "could not find nutrients" });
				});
		})
		.catch(err => {
			res.status(400).json({ err, error: "could not find meal" });
		});
});
//POST request to create an ingredients
server.post("/nutrients/:ingredientID", (req, res) => {
	//grabs the ingredient id from the req.params
	const ingredientId = req.params.ingredientID;
	//Grabs the id of the nutrient sent by req.body
	const id = req.body.id;
	const nutrient_id = { id };
	db("ingredients")
		//Finds the corrosponding nutrients based on ingredient ID
		.where({ id: ingredientId })
		.first()
		.then(ingredient => {
			//Appends the previous nutrient ID's and adds a new id at the end, seperated by a ,
			let oldNutrients = ingredient.nutrients_id;

			let newNutrients = oldNutrients + ", " + nutrient_id.id;
			db("ingredients")
				//Finds the corrosponding nutrients based on ingredient ID
				.where({ id: ingredientId })
				//Doing a where request returns an array, so we want the first index of that array.
				.first()
				//Reaplces the old nutrients with the new ones
				.update({ nutrients_id: newNutrients })
				.then(ingredients => {
					//Returns the ingredient
					db("ingredients")
						//Finds the corrosponding nutrients based on ingredient ID
						.where({ id: ingredientId })
						.first()
						.then(ingredient => {
							res.status(200).json(ingredient);
						})
						.catch(err => {
							res.status(400).json({ error: "error returning ingredient" });
						});
				})
				.catch(err => {
					res.status(400).json({ err, error: "could not add nutrients" });
				});
		});
});
//POST request so user can make their own nutrient
server.post("/nutrients/:id", (req, res) => {
	const user_id = req.params.id;
	//grabs the name unit and value from req.body
	const { name, unit, value } = req.body;
	//set the what we grabbed to a new "nutrient"
	const nutrient = { name, unit, value, user_id };

	db("nutrients")
		.insert(nutrient)
		.then(nutrientID => {
			//Returns the nutrient ID
			res.status(200).json(nutrientID);
		})
		.catch(err => {
			res.status(400).json({ err, error: "Error creating a new meal." });
		});
});

//PUT request to change the nutrient
server.put("/nutrients/:id", (req, res) => {
	//Grabs recipe ID from req.params
	const id = req.params.id;
	//grabs the name unit and value from req.body
	const { name, unit, value } = req.body;
	//set the what we grabbed to a new "nutrient"
	const nutrient = { name, unit, value };

	db("nutrients")
		.where({ id: id })
		.update({
			//UPDATES the name, calories etc of the recipe if needed.
			name: nutrient.name,
			unit: nutrient.unit,
			value: nutrient.value
		})
		.then(nutrientID => {
			//Returns the ID of the meal changed
			res.status(200).json(nutrientID);
		})
		.catch(err => {
			res.status(400).json({ error: "Could not update meal" });
		});
});
//PUT request to change the nutrient
server.put("/nutrients/ingredients/:ingredientID", (req, res) => {
	//Grabs recipe ID from req.params
	const id = req.params.ingredientID;

	//grabs the name unit and value from req.body
	const { ids } = req.body;
	//set the what we grabbed to a new "nutrient"
	const nutrient_ids = ids;

	db("ingredients")
		.where({ id: id })
		.first()
		.then(ingredient => {
			const test = "1,3,6,7";
			ingredient.nutrients_id.trim();
			let oldNutrients = ingredient.nutrients_id.split(",");
			let selectedIDS = nutrient_ids.split(",");

			let newNutrients = oldNutrients.filter(
				nutrients => !selectedIDS.includes(nutrients)
			);
			//Turns the filtered nutrients into a string (NOTE: might need toString() for funky data)
			let string = newNutrients.join();
			db("ingredients")
				//Finds the corrosponding nutrients based on ingredient ID
				.where({ id: id })
				//Doing a where request returns an array, so we want the first index of that array.
				.first()
				//Reaplces the old nutrients with the new ones
				.update({ nutrients_id: string })
				.then(ingredients => {
					//Returns the ingredient
					db("ingredients")
						//Finds the corrosponding nutrients based on ingredient ID
						.where({ id: id })
						.first()
						.then(ingredient => {
							res.status(200).json(ingredient);
						})
						.catch(err => {
							res.status(400).json({ error: "error returning ingredient" });
						});
				})
				.catch(err => {
					res.status(400).json({ err, error: "could not add nutrients" });
				});
		});
});

//DELETE a recipe
server.delete("/nutrients/:id", (req, res) => {
	//Grabs the id from the API endpoint (front end job)
	const { id } = req.params;
	db("nutrients")
		.where({ id: id })
		//Deletes the nutrient
		.del()
		.then(deleted => {
			//Should return 1 if deleted, returns 0 if not
			res.status(200).json(deleted);
		})
		.catch(err => {
			res.status(400).json({ error: "could not delete meals" });
		});
});

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//++++++++++++++++++++++++ NOTES ENDPOINTS +++++++++++++++++++++++++++++++++++++++++++++++++
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//Returns a list of notes associated with a meal
server.get("notes/:mealid", (req, res) => {
	const mealId = req.params.mealid;
	db("notes")
		//Finds the corrosponding note based on meal ID
		.where({ mealList_id: mealId })
		.then(note => {
			//Returns all the note from that meal
			res.status(200).json(note);
		})
		.catch(err => {
			res.status(400).json({ error: "could not find associated note" });
		});
});
//POST req to create a note and associate it to a meal
server.post("notes/:mealid", (req, res) => {
	//Grabs the meal id from req.params
	const mealId = req.params.mealid;
	const { notebody } = req.body;
	//Adds the meal id to the note to make it a part of that meal.
	const note = { notebody, mealId };
	db("notes")
		//Inserts the note into the notes table
		.insert(note)
		.then(note => {
			//Returns the note
			res.status(201).json(note);
		})
		.catch(err => {
			res.status(400).json({ error: "Could not create note" });
		});
});

//PUT request to change the notes body
server.put("/notes/:noteid", (req, res) => {
	const id = req.params.noteid;
	const { notebody } = req.body;
	const note = { notebody };
	db("notes")
		.where({ id: id })
		.update({
			notebody: note.notebody
		})
		.then(noteID => {
			//Returns the note ID
			res.status(200).json(noteID);
		})
		.catch(err => {
			res.status(400).json({ error: "Could not update note" });
		});
});
//Deletes a note
server.delete("/note/:noteid", (req, res) => {
	//Grabs note id from req.params
	const id = req.params.noteid;
	db("notes")
		.where({ id: id })
		.del()
		.then(deleted => {
			//Returns a 1 for deleted or a 0 for not.
			res.status(200).json(deleted);
		})
		.catch(err => {
			res.status(400).json({ error: "Error deleting note" });
		});
});

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//++++++++++++++++++++++++ WEATHER ENDPOINTS +++++++++++++++++++++++++++++++++++++++++++++++++
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//Returns the weather for that meal
server.get("/weather/:mealid", (req, res) => {
	const mealId = req.params.mealid;
	db("weather")
		//Finds the corrosponding weather data for that meal
		.where({ mealId: mealId })
		.then(weather => {
			//Returns the weather for that meal
			res.status(200).json(weather);
		})
		.catch(err => {
			res.status(400).json({ error: "could not find the weather data" });
		});
});
//POST req to create a weather report for that meal
server.post("/weather/:mealid", (req, res) => {
	//Grabs the meal id from req.params
	const mealId = req.params.mealid;
	const { name, description, temp, humidity, pressure } = req.body;
	//Adds the meal id to the weather object
	const weather = { name, description, temp, humidity, pressure, mealId };
	db("weather")
		//Inserts the weather and associates it to a meal
		.insert(weather)
		.then(weather => {
			//Returns the weather
			res.status(201).json(weather);
		})
		.catch(err => {
			res.status(400).json({ error: "Could not create weather" });
		});
});

//Deletes the weather for the meal
server.delete("/weather/:mealid", (req, res) => {
	//Grabs meal id from req.params
	const id = req.params.mealid;
	db("weather")
		//FInds the meal thats associated with that weather report
		.where({ mealId: id })
		.del()
		.then(deleted => {
			//Returns a 1 for deleted or a 0 for not.
			res.status(200).json(deleted);
		})
		.catch(err => {
			res.status(400).json({ error: "Error deleting weather data" });
		});
});

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//++++++++++++++++++++++++ ALARMS ENDPOINTS +++++++++++++++++++++++++++++++++++++++++++++++++
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//Returns the alarms for that user
server.get("/alarms/:userid", (req, res) => {
	const user_ID = req.params.userid;
	db("alarms")
		//Finds the alarms associated to that user
		.where({ user_id: user_ID })
		.then(alarms => {
			//Returns the alarms for that user
			res.status(200).json(alarms);
		})
		.catch(err => {
			res.status(400).json({ error: "could not find the alarms" });
		});
});
//POST req to create a alarm for the user
server.post("/alarms/:userid", (req, res) => {
	//Grabs the user id from req.params
	const user_ID = req.params.userid;
	const { beginTime, endTime, beginLimit, endLimit, repeats } = req.body;
	//Adds the user id to the alarm object
	const alarm = { beginTime, endTime, beginLimit, endLimit, repeats, user_ID };
	db("alarms")
		//Inserts the alarm and sets it to the user
		.insert(alarm)
		.then(alarm => {
			//Returns the alarm
			res.status(201).json(alarm);
		})
		.catch(err => {
			res.status(400).json({ msg: err, error: "Could not create alarm" });
		});
});

//PUT request to change the alarm settings
server.put("/alarms/:id", (req, res) => {
	//Grabs the alarm id from req.params
	const id = req.params.userid;
	const { beginTime, endTime, beginLimit, endLimit, repeat } = req.body;
	// Sets the req.body to an alarm object that gets passed into the update
	const alarm = { beginTime, endTime, beginLimit, endLimit, repeat };
	db("alarms")
		.where({ id: id })
		.update({
			beginTime: alarm.beginTime,
			endTime: alarm.endTime,
			beginLimit: alarm.beginLimit,
			endLimit: alarm.beginLimit,
			repeat: alarm.repeat
		})
		.then(alarmID => {
			//Returns the alarm ID
			res.status(200).json(alarmID);
		})
		.catch(err => {
			res.status(400).json({ error: "Could not update alarm" });
		});
});

//Deletes the alarm for the user
server.delete("/alarms/:id", (req, res) => {
	//Grabs alarm id from req.params
	const id = req.params.mealid;
	db("alarms")
		//FInds the meal thats associated with that weather report
		.where({ id: id })
		.del()
		.then(deleted => {
			//Returns a 1 for deleted or a 0 for not.
			res.status(200).json(deleted);
		})
		.catch(err => {
			res.status(400).json({ error: "Error deleting alarm" });
		});
});

server.listen(port, () => {
	console.log(`Server now listening on Port ${port}`);
});
