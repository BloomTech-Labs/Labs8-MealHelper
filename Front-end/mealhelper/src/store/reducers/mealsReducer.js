import {
	ADDING_MEALS,
	ADDED_MEALS,
	ADDING_MEAL_ERRORS,
	ADDING_MEAL,
	ADDED_MEAL,
	ADDING_MEAL_ERROR,
	GETTING_SINGLE_MEAL,
	GOT_SINGLE_MEAL,
	GETTING_SINGLE_MEAL_ERROR,
	GETTING_MEALS,
	GOT_MEALS,
	GETTING_MEALS_ERROR,
	PUTTING_MEAL,
	PUT_MEAL,
	PUTTING_MEAL_ERROR,
	DELETING_MEAL,
	DELETED_MEAL,
	DELETING_MEAL_ERROR
} from "../actions/mealActions";

/* Meals Reducer */

const initialState = {
	meals: [],
	singleMeal: [],
	gettingMeals: false,
	gettingMeal: false,
	addingMeal: false,
	updatingMeal: false,
	deletingMeal: false,
	error: ""
};

export const mealsReducer = (state = initialState, action) => {
	switch (action.type) {
		case ADDING_MEALS:
			//Initial adding user
			return { ...state, addingMeal: true };
		case ADDED_MEALS:
			//Returns the user ID and the JWT token and sets it as JSON to user
			return { ...state, addingMeal: false, meals: action.payload };
		case ADDING_MEAL_ERRORS:
			//Shoots off if there is an error creating a new user
			return { ...state, addingMeal: false, error: action.payload };
		case ADDING_MEAL:
			//Initial adding user
			return { ...state, addingMeal: true };
		case ADDED_MEAL:
			//Returns the user ID and the JWT token and sets it as JSON to user
			return {
				...state,
				addingMeal: false,
				singleMeal: action.payload,
				meals: action.payload
			};
		case ADDING_MEAL_ERROR:
			//Shoots off if there is an error creating a new user
			return { ...state, addingMeal: false, error: action.payload };
		case GETTING_SINGLE_MEAL:
			return { ...state, gettingMeal: true };
		case GOT_SINGLE_MEAL:
			return { ...state, gettingMeal: false, meal: action.payload };
		case GETTING_SINGLE_MEAL_ERROR:
			return { ...state, gettingMeal: false, error: action.payload };
		case GETTING_MEALS:
			//Initial logging in user
			return { ...state, gettingMeals: true };
		case GOT_MEALS:
			//Returns the user ID and the JWT token and sets it as JSON to user
			return { ...state, gettingMeals: false, meals: action.payload };
		case GETTING_MEALS_ERROR:
			//Shoots off if there is an error logging in a user
			return { ...state, gettingMeals: false, error: action.payload };
		case PUTTING_MEAL:
			//Initial deleting a user
			return { ...state, updatingMeal: true };
		case PUT_MEAL:
			//Returns a 1 if deleted and sets that in the user array (front end check for that)
			return { ...state, updatingMeal: false, meals: action.payload };
		case PUTTING_MEAL_ERROR:
			//Shoots off if there is an error deleting a user
			return { ...state, updatingMeal: false, error: action.payload };

		case DELETING_MEAL:
			//Initial updating of a user
			return { ...state, deletingMeal: true };
		case DELETED_MEAL:
			//Returns the user ID and a new JWT token
			return { ...state, deletingMeal: false, meals: action.payload };
		case DELETING_MEAL_ERROR:
			//Shoots off if there is an error updating a user
			return { ...state, deletingMeal: false, error: action.payload };
		default:
			return state;
	}
};
