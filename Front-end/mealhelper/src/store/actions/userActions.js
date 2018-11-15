import axios from "axios";

//User
export const ERROR = "ERROR";
export const ADDING_USER = "ADDING_USER";
export const ADDED_USER = "ADDED_USER";
export const ADDING_USER_ERROR = "ADDING_USER_ERROR";
export const ADDING_AUTH_USER = "ADDING_AUTH_USER";
export const GOT_AUTH_USER = "GOT_AUTH_USER";
export const GETTING_AUTH_USER_ERROR = "GETTING_AUTH_USER_ERROR";
export const GETTING_USER = "GETTING_USER";
export const GOT_USER = "GOT_USER";
export const GETTING_USERS_ERROR = "GETTING_USERS_ERROR";
export const GETTING_USER_ERROR = "GETTING_USER_ERROR";
export const CHANGING_USER = "CHANGING_USER";
export const CHANGED_USER = "CHANGED_USER";
export const CHANGING_USER_ERROR = "CHANGING_USER_ERROR";
export const DELETING_USER = "DELETING_USER";
export const DELETED_USER = "DELETED_USER";
export const DELETING_USER_ERROR = "DELETING_USER_ERROR";
//Route to sign up a user
export const addUser = credentials => dispatch => {
	dispatch({ type: ADDING_USER });
	//Passes credentials to the /register Route.
	const promise = axios.post(
		"https://labs8-meal-helper.herokuapp.com/register",
		credentials
	);
	promise
		.then(response => {
			dispatch({ type: ADDED_USER, payload: response.data });
		})
		.catch(err => {
			dispatch({ type: ADDING_USER_ERROR, payload: err });
		});
};
//Route to login a user
export const loginUser = credentials => dispatch => {
	dispatch({ type: GETTING_USER });

	axios
		//Passes credentials to the /login Route.
		.post("https://labs8-meal-helper.herokuapp.com/login", credentials)
		.then(response => {
			dispatch({ type: GOT_USER, payload: response.data });
		})
		.catch(err => {
			dispatch({ type: GETTING_USERS_ERROR, payload: err });
		});
};
//login auth user
export const loginAuthUser = credentials => dispatch => {
	dispatch({ type: ADDING_AUTH_USER });

	axios
		//Passes credentials to the /login Route.
		.post("https://labs8-meal-helper.herokuapp.com/registerAuth0", credentials)
		.then(response => {
			dispatch({ type: GOT_AUTH_USER, payload: response.data });
		})
		.catch(err => {
			dispatch({ type: GETTING_AUTH_USER_ERROR, payload: err });
		});
};
//PUT REQ to change user settings
export const updateUser = credentials => dispatch => {
	dispatch({ type: CHANGING_USER });

	axios
		//Passes credentials to the /login Route.
		//Credentials should pass the id in its object so we can uniquely have it in our axios req
		.put(
			`https://labs8-meal-helper.herokuapp.com/users/${credentials.id}`,
			credentials
		)
		.then(response => {
			dispatch({ type: CHANGED_USER, payload: response.data });
		})
		.catch(err => {
			dispatch({ type: CHANGING_USER_ERROR, payload: err });
		});
};
//Deleting user action
export const deleteUser = id => dispatch => {
	dispatch({ type: DELETING_USER });

	axios

		//ID is passed in and gets set to the dynamic route here.
		.delete(`https://labs8-meal-helper.herokuapp.com/users/${id}`)
		.then(response => {
			//Reponse should be a 1 for deleted
			dispatch({ type: DELETED_USER, payload: response.data });
		})
		.catch(err => {
			dispatch({ type: DELETING_USER_ERROR, payload: err });
		});
};
