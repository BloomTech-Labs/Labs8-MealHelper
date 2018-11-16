import { combineReducers } from "redux";
import { mealsReducer } from "./mealsReducer";
import { weatherReducer } from "./weatherReducer";
import { recipesReducer } from "./recipesReducer";
import { ingredsReducer } from "./ingredsReducer";
import { alarmsReducer } from "./alarmsReducer";
import { userReducer } from "./userReducer";

export default combineReducers({
	mealsReducer,
	weatherReducer,
	recipesReducer,
	ingredsReducer,
	alarmsReducer,
	userReducer
});
