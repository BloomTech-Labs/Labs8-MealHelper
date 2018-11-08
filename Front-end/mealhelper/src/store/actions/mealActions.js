import axios from "axios";
/* MEAL ACTIONS */

//Action Types
export const ERROR = "ERROR";

export const GET_MEALS = "GET_MEALS";
export const GETTING_MEALS = "GETTING_MEALS";

export const GET_SINGLE_MEAL = "GET_SINGLE_MEAL";
export const GETTING_SINGLE_MEAL = "GETTING_SINGLE_MEAL";

export const CREATING_MEAL = "CREATING_MEAL";
export const CREATE_MEAL = "CREATE_MEAL";

export const UPDATE_MEAL = "UPDATE_MEALS";
export const UPDATING_MEAL = "UPDATING_MEAL";

export const DELETE_MEAL = "DELETE_MEAL";
export const DELETING_MEAL = "DELETING_MEAL";

/*
Alternatively, I believe we could reduce Action Types by replacing all *ING_MEAL types with something like FETCHING_DATA
*/

//Action Creators

//Gets a list of meals
export const getMeals = () => {
  return dispatch => {
    dispatch({ type: GETTING_MEALS });
    /* Alternatively:
    dispatch({ type: FETCHING_DATA })
    */
  
    axios
      .get(/*'URL'*/)
      .then(response => {
        dispatch({
          type: GET_MEALS,
          payload: response.data
        });
      })
      .catch(err => {
        dispatch({
          type: ERROR,
          payload: "error getting meals",
          err
        });
      });
  };
};

//Gets a single meal with id
export const getSingleMeal = id => {
  return dispatch => {
    dispatch({ type: GETTING_SINGLE_MEAL });
    /* Alternatively:
    dispatch({ type: FETCHING_DATA })
    */
    axios
      .get(/*'URL'*/)
      .then(({ data }) => {
        dispatch({
          type: GET_SINGLE_MEAL,
          payload: data
        });
      })
      .catch(err => {
        dispatch({
          type: ERROR,
          payload: "error getting single meal",
          err
        });
      });
  };
};
