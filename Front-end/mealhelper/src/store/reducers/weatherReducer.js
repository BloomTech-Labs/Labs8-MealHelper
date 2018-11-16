import {
	ADDING_WEATHER,
	ADDED_WEATHER,
	ADDING_WEATHER_ERROR,
	GETTING_WEATHER,
	GOT_WEATHER,
	GETTING_WEATHER_ERROR
} from "../actions/weatherActions";
import axios from "axios";

let initialState = {
	weather: [],
	addingWeather: false,
	gettingWeather: false,
	error: null
};

export const userReducer = (state = initialState, action) => {
	switch (action.type) {
		case ADDING_WEATHER:
			//Initial adding ingredient
			return { ...state, addingWeather: true };
		case ADDED_WEATHER:
			//Adds ingredient to the store
			return { ...state, addingWeather: false, weather: action.payload };
		case ADDING_WEATHER_ERROR:
			//Shoots off if there is an error creating a new ingredient
			return { ...state, addingWeather: false, error: action.payload };
		case GETTING_WEATHER:
			return { ...state, gettingWeather: true };
		case GOT_WEATHER:
			return { ...state, gettingWeather: false, weather: action.payload };
		case GETTING_WEATHER_ERROR:
			return { ...state, gettingWeather: false, error: action.payload };
		default:
			return state;
	}
};
