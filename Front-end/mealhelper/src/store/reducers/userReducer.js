//imports all our actions from the userActions files
import {
	ADDING_USER,
	ADDED_USER,
	ADDING_USER_ERROR,
	GETTING_USER,
	GOT_USER,
	GETTING_USERS_ERROR,
	DELETING_USER,
	DELETED_USER,
	CHANGING_USER,
	CHANGED_USER,
	ERROR
} from "../actions/userActions";
import axios from "axios";

let initialState = {
	user: [],
	addingUser: false,
	gettingUser: false,
	deletingUser: false,
	changingUser: false,
	error: null
};

export const noteReducer = (state = initialState, action) => {
	switch (action.type) {
		case ADDING_USER:
			//Initial adding user
			return { ...state, addingUser: true };
		case ADDED_USER:
			//grabs the data from API in action payload and sets it as JSON to the user array
			return { ...state, addingUser: false, user: action.payload };
		case ADDING_USER_ERROR:
			//Shoots off if there is an error creating a new user
			return { ...state, fetchingNotes: false, error: action.payload };
		case GETTING_USER:
			//Initial logging in user
			return { ...state, gettingUser: true };
		case GOT_USER:
			return { ...state, gettingUser: false, user: action.payload };
		case GETTING_USERS_ERROR:
			return { ...state, gettingUser: false, error: action.payload };
		case DELETING_USER:
			return { ...state, deletingUser: true };
		case DELETED_USER:
			return { ...state, deletingUser: false, user: action.payload };
		case ADDING_NOTE_ERROR:
			return { ...state, addingNotes: false, error: action.payload };

		case DELETING_NOTE:
			return { ...state, deletingNote: true };
		case DELETED_NOTE:
			return { ...state, deletingNote: false, notes: action.payload };
		case DELETED_NOTE_ERROR:
			return { ...state, deletingNote: false, error: action.payload };
		default:
			return state;
	}
};
