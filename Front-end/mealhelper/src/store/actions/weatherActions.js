import axios from "axios";

//Ingredient
export const ADDING_WEATHER = "ADDING_WEATHER";
export const ADDED_WEATHER = "ADDED_WEATHER";
export const ADDING_WEATHER_ERROR = "ADDING_WEATHER_ERROR";
export const GETTING_WEATHER = "GETTING_WEATHER";
export const GOT_WEATHER = "GOT_WEATHER";
export const GETTING_WEATHER_ERROR = "GETTING_WEATHER_ERROR";

//Route to sign up a user
export const addWeather = weather => dispatch => {
	dispatch({ type: ADDING_WEATHER });
	const mealID = weather.user_id;
	const promise = axios.post(
		`https://labs8-meal-helper.herokuapp.com/weather/${mealID}`,
		weather
	);
	promise
		.then(response => {
			dispatch({ type: ADDED_WEATHER, payload: response.data });
		})
		.catch(err => {
			dispatch({ type: ADDING_WEATHER_ERROR, payload: err });
		});
};
export const addWeatherByUser = weather => dispatch => {
	dispatch({ type: ADDING_WEATHER });
	const user_id = weather.user_id;
	console.log(weather);
	const promise = axios.post(
		`https://labs8-meal-helper.herokuapp.com/weather/user/${user_id}`,
		weather
	);
	promise
		.then(response => {
			dispatch({ type: ADDED_WEATHER, payload: response.data });
		})
		.catch(err => {
			dispatch({ type: ADDING_WEATHER_ERROR, payload: err });
		});
};
//Route to login a user
export const getWeatherByMealID = id => dispatch => {
	dispatch({ type: GETTING_WEATHER });
	const mealID = id.user_id;
	axios

		.get(`https://labs8-meal-helper.herokuapp.com/weather/${mealID}`)
		.then(response => {
			dispatch({ type: GOT_WEATHER, payload: response.data });
		})
		.catch(err => {
			dispatch({ type: GETTING_WEATHER_ERROR, payload: err });
		});
};

export const getWeatherByUserID = id => dispatch => {
	dispatch({ type: GETTING_WEATHER });
	const userID = id.user_id;
	axios

		.get(`https://labs8-meal-helper.herokuapp.com/weather/${userID}`)
		.then(response => {
			dispatch({ type: GOT_WEATHER, payload: response.data });
		})
		.catch(err => {
			dispatch({ type: GETTING_WEATHER_ERROR, payload: err });
		});
};
