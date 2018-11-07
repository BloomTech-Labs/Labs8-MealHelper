import axios from 'axios';
/* MEAL ACTIONS */

//Action Types
export const ERROR = 'ERROR';

export const GET_MEALS = 'GET_MEALS';
export const GETTING_MEALS = 'GETTING_MEALS';

export const SINGLE_MEAL = 'SINGLE_MEAL';

export const CREATING_MEAL = 'CREATING_MEAL';
export const CREATE_MEAL = 'CREATE_MEAL';

export const UPDATE_MEAL = 'UPDATE_MEALS';
export const UPDATING_MEAL = 'UPDATING_MEAL';

export const DELETE_MEAL = 'DELETE_MEAL';
export const DELETING_MEAL = 'DELETING_MEAL';


//Action Creators

export const getMeals = () => {
  return dispatch => {
    dispatch({ type: GETTING_MEALS });
    
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
          payload: "error getting meals", err
        });
      });
  };
}