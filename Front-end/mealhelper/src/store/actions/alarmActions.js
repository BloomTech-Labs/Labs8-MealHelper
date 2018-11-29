/* ALARM ACTIONS */
import axios from "axios";

//Action Types
export const ADDING_ALARMS = "ADDING_ALARMS";
export const ADDED_ALARMS = "ADDED_ALARMS";
export const ADDING_ALARMS_ERROR = "ADDING_ALARMS_ERROR";

//Action Creators
export const addAlarms = alarms => dispatch => {
  dispatch({ type: ADDING_ALARMS });
  console.log(alarms);
  const user_id = alarms.user_id;
  axios
    .post(`https://labs8-meal-helper.herokuapp.com/alarms/1`, alarms)
    .then(response => {
      dispatch({ type: ADDED_ALARMS, payload: response.data });
    })
    .catch(err => {
      dispatch({ type: ADDING_ALARMS_ERROR, payload: err });
    });
}