import { combineReducers } from "redux";
import { mealsReducer } from "./mealsReducer";
import { recipesReducer } from "./recipesReducer";
import { ingredsReducer } from "./ingredsReducer";
import { alarmsReducer } from "./alarmsReducer";

export default combineReducers({
  mealsReducer,
  recipesReducer,
  ingredsReducer,
  alarmsReducer
});
