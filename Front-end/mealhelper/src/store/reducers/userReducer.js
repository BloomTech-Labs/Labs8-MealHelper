//imports all our actions from the userActions files
import {
	ADDING_USER,
	ADDED_USER,
	ADDING_USER_ERROR,
	ADDING_AUTH_USER,
	GOT_AUTH_USER,
	GETTING_AUTH_USER_ERROR,
	GETTING_USER,
	GOT_USER,
	GETTING_USERS_ERROR,
	DELETING_USER,
	DELETED_USER,
	DELETING_USER_ERROR,
	CHANGING_USER,
	CHANGED_USER,
	CHANGING_USER_ERROR
} from "../actions/userActions";
import axios from "axios";

let initialState = {
	user: [],
	addingUser: false,
	addingAuthUser: false,
	gettingUser: false,
	deletingUser: false,
	changingUser: false,
	error: null
};

export const userReducer = (state = initialState, action) => {
	switch (action.type) {
		case ADDING_USER:
			//Initial adding user
			return { ...state, addingUser: true };
		case ADDED_USER:
			//Returns the user ID and the JWT token and sets it as JSON to user
			return { ...state, addingUser: false, user: action.payload };
		case ADDING_USER_ERROR:
			//Shoots off if there is an error creating a new user
			return { ...state, fetchingNotes: false, error: action.payload };
		case ADDING_AUTH_USER:
			return { ...state, addingAuthUser: true };
		case GOT_AUTH_USER:
			return { ...state, addingAuthUser: false, user: action.payload };
		case GETTING_AUTH_USER_ERROR:
			return { ...state, addingAuthUser: false, error: action.payload };
		case GETTING_USER:
			//Initial logging in user
			return { ...state, gettingUser: true };
		case GOT_USER:
			//Returns the user ID and the JWT token and sets it as JSON to user
			return { ...state, gettingUser: false, user: action.payload };
		case GETTING_USERS_ERROR:
			//Shoots off if there is an error logging in a user
			return { ...state, gettingUser: false, error: action.payload };
		case DELETING_USER:
			//Initial deleting a user
			return { ...state, deletingUser: true };
		case DELETED_USER:
			//Returns a 1 if deleted and sets that in the user array (front end check for that)
			return { ...state, deletingUser: false, user: action.payload };
		case DELETING_USER_ERROR:
			//Shoots off if there is an error deleting a user
			return { ...state, deletingUser: false, error: action.payload };

		case CHANGING_USER:
			//Initial updating of a user
			return { ...state, changingUser: true };
		case CHANGED_USER:
			//Returns the user ID and a new JWT token
			return { ...state, changingUser: false, user: action.payload };
		case CHANGING_USER_ERROR:
			//Shoots off if there is an error updating a user
			return { ...state, changingUser: false, error: action.payload };
		default:
			return state;
	}
};
