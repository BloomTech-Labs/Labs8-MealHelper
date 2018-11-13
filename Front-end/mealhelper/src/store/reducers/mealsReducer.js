import {
  ERROR,
  GET_MEALS,
  GETTING_MEALS,
  GET_SINGLE_MEAL,
  GETTING_SINGLE_MEAL,
  CREATING_MEAL,
  CREATE_MEAL,
  UPDATE_MEALS,
  UPDATING_MEAL,
  DELETE_MEAL,
  DELETING_MEAL
} from "../actions";

/* Meals Reducer */

const initialState = {
  meals: [],
  singleMeal: {},
  gettingMeals: false,
  getMeals: false,
  creatingMeal: false,
  updatingMeal: false,
  deletingMeal: false,
  error: ""
};

/*
Alternatively, initialState could look like this:

const initialState = {
  meals: [],
  singleMeal: {},
  getting: false,
  success: false,
  error: ''
}

*/

/*
export const mealsReducer = (state = initialState, action) => {
  switch (action.type) {
    case GETTING_MEALS:
      return {
        ...state,
        gettingMeals: true,
        getMeals: false
      };
      /*
      Using alternate initialState:
      return {
        ...state, 
        getting: true, 
        success: false
      } 
      */
    // case GET_MEALS:
    //   return {
    //     ...state,
    //     meals: action.payload,
    //     gettingMeals: false,
    //     getMeals: true
    //   };
      /*
      Using alternate initialState:
      return {
        ...state, 
        meal: action.payload,
        getting: false, 
        success: true
      } 
      */
//     case CREATING_MEAL:
//       return {
//         ...state,
//         creatingMeal: true
//       };
//     case CREATE_MEAL:
//       return {
//         ...state,
//         creatingMeal: false
//       };
//   }
// };
