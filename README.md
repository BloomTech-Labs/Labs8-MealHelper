# Users Endpoints

## POST /register

- allows you to register a user.
- Uses Bcrypt for hasing the password and storing it.
- Returns: the user and a token from JWTToken

## POST /login

- Allows a registered user to log in
- Takes the entered password and hashes it to compare with the stored one.
- Returns: the user and a token from JWTToken

## PUT /users/:id

- Allows a user to change their username, zip, health condition or password/
- Requires them to type in their old password (front end will be saved as password).
- Takes in the new password and hashes it, if old password matches what is stored in db, it will set password to the new hash pass.
- Returns: the user and a token from JWTToken

## DELETE /users/:id

- Deletes the user.
- If user is deleted, SHOULD cascade all stored data associated with that user ID.
- Returns: a 1 for deleted (or true) or a 0 if they werent (deleted).


# Meal List Endpoints

## GET /users/:userid/meals

- Requires a user ID in req params to return the users meals.
- Returns: An array of meals associated with that user ID.

## POST /users/:userid/meals

- Requires a user ID to associate the meal too.
- *NOTE* Must decide if we want the user ID to come from params or from req.body, requires further discussion, for now uses req.body.
- Returns: The id of the meal itself.

## PUT /meals/:mealID

- Requires a meal ID from req.params.
- Requires recipe_id, user_id, mealTime, experience in req.body.
- Returns: The meal ID.

## DELETE /users/:id/meals/:mealId

- Requires the meal ID.
- Deletes the meal associated with the Meal ID.
- Returns: A 1 if deleted, a 0 if not deleted.

## DELETE /users/:id/meals/

- Requires the user ID.
- Deletes all the meals associated with the user ID.
- Returns: A 1 if deleted, a 0 if not deleted

# Recipe Endpoints

## GET /recipe
**NOTE: THIS IS A DEVELOPER ROUTE ONLY FOR TESTING PURPOSES**
- Returns: All the recipes stored in the DB>

## GET /recipe/:userid

- Requires a user ID.
- Returns: An array of all recipes associated with that user.

## POST /recipe/:userid

- Requires a user ID.
- The route used to add a new recipe
- Returns: the ID of the recipe after its been created.

## PUT /recipe/:id

- Requires the ID of the recipe
- Allows the changing of the recipe.
- Returns: the ID of the recipe thats been updated.

## DELETE /recipe/:id

- Requires the id of the recipe to be deleted.
- Returns: A 1 if deleted, a 0 if not deleted.

# Ingredients Endpoints

## GET /ingredients
**NOTE: THIS IS A DEV ONLY ENDPOINT FOR TESTING ONLY**

- Returns: an array of all ingredients.

## GET /ingredients/:userid

- Requires a user ID.
- Returns: an array of ingredients made by that user.

## POST /ingredients/:userid

- Requires a user id.
- When grabbing an ingredient from api or creating a new ingredient, needs to associate to a user.
- Returns: the new ingredient ID.

## PUT /ingredients/:id

- Requires the id of the ingredient.
- Changes the nbd_id (from api), the name of the ingredient, or the nutrients associated with it (not a problem if API grabbed).
- Returns: the id of the ingredient.

## DELETE /ingredients/:id

- Requires the id of the ingredient.
- Returns: a 1 if deleted, a 0 if not deleted.

# Nutrients Endpoints

## GET /nutrients
**NOTE: DEVELOPER ROUTE ONLY, TESTING ONLY PLEASE**

- Returns all nutrients.

## GET /nutrients/:ingredientID

- Requires an ingredient ID
- Returns the nutrients from an ingredient.

## POST /nutrients/:ingredientID

- Requires an ingredient ID.
- Creates a new nutrient for an ingredient.
- Returns the ingredient.

## POST /nutrients/:id
- Requires the user id from req.params
- Requires the name, unit, value,  from req.body
- Allows a user to make their own nutrient.
- Returns the nutrient id.

## PUT /nutrients/:id

- Requires the nutrient id from req.params
- Requires the name, unit, value,  from req.body
- Returns the nutrient ID that was updated.

## PUT /nutrients/ingredients/:ingredientID

- Requires the ingredient ID.
- Allows a user to select more than one nutrient from an ingredient to delete.
- Returns the ingredient that had its nutrients changed.

## DELETE /nutrients/:id

- Requires the nutrients id.
- Returns a 1 for deleted, or a 0 for not deleted.

# Notes Endpoints

## GET notes/:mealid

- Requires the meal id.
- Returns: the notes for that meal.

## POST notes/:mealid

- Requires the meal ID.
- Takes in notebody from req.body
- Returns: the note associated to that meal.

## PUT /notes/:noteid

- Requires the id of the note.
- Takes in the notebody from req.body
- Returns the id of the changed note.

## DELETE /notes/:noteid

- Requires the id of the note.
- Returns a 1 if deleted, a 0 if not.

# Weather Endpoints

## GET /weather/:mealid

- Requires the meal ID.
- Returns: The weather report for that meal.

## POST /weather/:mealid

- Requires the meal ID from req.params to associate the weather too. 
- Requires the name, description, temp, humidity, pressure from req.body
- Returns the weather that was posted.

## DELETE /weather/:mealid

- Requires: the meal id from req. params. (NOTE: One weather report per meal should be the goal.)
- Returns: a 1 if deleted, and a 0 if not.

# Alarms Endpoints

## GET /alarms/:userid

- Requires the user id from req.params.
- Returns: the alarms for that user.

## POST /alarms/:userid

- Requires the user ID from req.params.
- Takes in beginTime, endTime, beginLimit, endLimit, repeat from req.body
- Returns: the alarm associated to that user.

## PUT /alarms/:id

- Requires the id of the alarm.
- Takes in the beginTime, endTime, beginLimit, endLimit, repeat from req.body
- Returns the id of the changed alarm.

## DELETE /alarms/:id

- Requires the id of the alarm.
- Returns a 1 if deleted, a 0 if not.
