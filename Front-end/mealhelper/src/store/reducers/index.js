import { combineReducers } from "redux";
import { mealsReducer } from "./mealsReducer";
import { weatherReducer } from "./weatherReducer";
import { recipesReducer } from "./recipesReducer";
import { ingredsReducer } from "./ingredsReducer";
import { alarmsReducer } from "./alarmsReducer";
import { userReducer } from "./userReducer";
import { nutrientsReducer } from "./nutrientsReducer";

export default combineReducers({
  mealsReducer,
  weatherReducer,
  recipesReducer,
  ingredsReducer,
  nutrientsReducer,
  alarmsReducer,
  userReducer
});
