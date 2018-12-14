import axios from "axios";

//Ingredient
export const ADDING_MEAL = "ADDING_MEAL";
export const ADDED_MEAL = "ADDED_MEAL";
export const ADDING_MEAL_ERROR = "ADDING_MEAL_ERROR";
export const ADDING_MEALS = "ADDING_MEALS";
export const ADDED_MEALS = "ADDED_MEALS";
export const ADDING_MEAL_ERRORS = "ADDING_MEAL_ERRORS";
export const GETTING_SINGLE_MEAL = "GETTING_SINGLE_MEAL";
export const GOT_SINGLE_MEAL = "GOT_SINGLE_MEAL";
export const GETTING_SINGLE_MEAL_ERROR = "GETTING_SINGLE_MEAL_ERROR";
export const GETTING_MEALS = "GETTING_MEALS";
export const GOT_MEALS = "GOT_MEALS";
export const GETTING_MEALS_ERROR = "GETTING_MEALS_ERROR";
export const PUTTING_MEAL = "PUTTING_MEAL";
export const PUT_MEAL = "PUT_MEAL";
export const PUTTING_MEAL_ERROR = "PUTTING_MEAL_ERROR";
export const DELETING_MEAL = "DELETING_MEAL";
export const DELETED_MEAL = "DELETED_MEAL";
export const DELETING_MEAL_ERROR = "DELETING_MEAL_ERROR";

//Route to sign up a user
export const addMeal = meal => dispatch => {
	dispatch({ type: ADDING_MEAL });
	const user_id = meal.user_id;
	console.log(meal);
	const promise = axios.post(
		`https://labs8-meal-helper.herokuapp.com/users/${user_id}/meals`,
		meal
	);
	promise
		.then(response => {
			dispatch({ type: ADDED_MEAL, payload: response.data });
		})
		.catch(err => {
			dispatch({ type: ADDING_MEAL_ERROR, payload: err });
		});
};
//Route to login a user
export const getMeals = id => dispatch => {
	dispatch({ type: GETTING_MEALS });

	axios

		.get(`https://labs8-meal-helper.herokuapp.com/users/${id}/meals`)
		.then(response => {
			dispatch({ type: GOT_MEALS, payload: response.data });
		})
		.catch(err => {
			dispatch({ type: GETTING_MEALS_ERROR, payload: err });
		});
};

export const getMeal = (mealID, userID) => dispatch => {
	dispatch({ type: GETTING_SINGLE_MEAL });
	const meal_id = mealID;
	const user_id = userID;
	axios

		.get(
			`https://labs8-meal-helper.herokuapp.com/users/${user_id}/meals/${meal_id}`
		)
		.then(response => {
			dispatch({ type: GOT_SINGLE_MEAL, payload: response.data });
		})
		.catch(err => {
			dispatch({ type: GETTING_SINGLE_MEAL_ERROR, payload: err });
		});
};

export const changeMeal = meal => dispatch => {
	dispatch({ type: PUTTING_MEAL });
	const mealID = meal.mealID;
	axios

		.put(`https://labs8-meal-helper.herokuapp.com/meals/${mealID}`, meal)
		.then(response => {
			dispatch({ type: PUT_MEAL, payload: response.data });
		})
		.catch(err => {
			dispatch({ type: PUTTING_MEAL_ERROR, payload: err });
		});
};
export const deleteMeal = id => dispatch => {
	dispatch({ type: DELETING_MEAL });
	const meal_id = id.mealID;
	const user_id = id.userID;
	axios

		.delete(
			`https://labs8-meal-helper.herokuapp.com/users/${user_id}/meals/${meal_id}`
		)
		.then(response => {
			dispatch({ type: DELETED_MEAL, payload: response.data });
		})
		.catch(err => {
			dispatch({ type: DELETING_MEAL_ERROR, payload: err });
		});
};
