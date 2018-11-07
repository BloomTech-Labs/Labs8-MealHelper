# Users Endpoints

## POST /register

- allows you to register a user.
- Uses Bcrypt for hasing the password and storing it.
- Returns: the user and a token from JWTToken

## POST /login

- Allows a registered user to log in
- Takes the entered password and hashes it to compare with the stored one.
- Returns: a welcome with the username, a token, and the id of the user.

## PUT /users/:id

- Allows a user to change their username, zip, health condition or password/
- Requires them to type in their old password (front end will be saved as password).
- Takes in the new password and hashes it, if old password matches what is stored in db, it will set password to the new hash pass.
- Returns: A new token, and the user ID

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
