/* ALARM ACTIONS */
import axios from "axios";

//Action Types
export const FETCHING_ALARMS = "FETCHING_ALARMS";
export const FETCHED_ALARMS = "FETCHED_ALARMS";
export const FETCHING_ALARMS_ERROR = "FETCHING_ALARMS_ERROR";
export const ADDING_ALARMS = "ADDING_ALARMS";
export const ADDED_ALARMS = "ADDED_ALARMS";
export const ADDING_ALARMS_ERROR = "ADDING_ALARMS_ERROR";
export const DELETING_ALARM = "DELETING_ALARM";
export const DELETED_ALARM = "DELETED_ALARM";
export const DELETING_ALARM_ERROR = "DELETING_ALARM_ERROR";
export const UPDATING_ALARM = "UPDATING_ALARM";
export const UPDATED_ALARM = "UPDATED_ALARM";
export const UPDATING_ALARM_ERROR = "UPDATING_ALARM_ERROR";

//Action Creators
export const fetchAlarms = () => dispatch => {
  //const { id } = req.params;
  dispatch({ type: FETCHING_ALARMS });
  const promise = axios.get(
    `https://labs8-meal-helper.herokuapp.com/alarms/`
  );
  promise
    .then(response => {
      dispatch({ type: FETCHED_ALARMS, payload: response.data });
    })
    .catch(err => {
      dispatch({ type: FETCHING_ALARMS_ERROR, payload: err })
    })
}

export const addAlarms = alarms => dispatch => {
  dispatch({ type: ADDING_ALARMS });
  console.log("ALARMS", alarms);
  const user_id = alarms.user_id;
  axios
    .post(`https://labs8-meal-helper.herokuapp.com/alarms/${user_id}`, alarms)
    .then(response => {
      dispatch({ type: ADDED_ALARMS, payload: response.data });
    })
    .catch(err => {
      dispatch({ type: ADDING_ALARMS_ERROR, payload: err });
    });
}

export const deleteAlarm = id => dispatch => {
  dispatch({ type: DELETING_ALARM });
  axios
    .delete(`URL`)
    .then(response => {
      dispatch({ type: DELETED_ALARM, payload: response.data });
    })
    .catch(err => {
      dispatch({ type: DELETING_ALARM_ERROR, payload: err });
    });
}

export const updateAlarm = alarm => dispatch => {
  const id = alarm.id;
  const label = alarm.label;
  const alarm = alarm.alarm;
  const updatedAlarm = { label, alarm };
  dispatch({ type: UPDATING_ALARM });
  axios
    .put( `URL`, updatedAlarm)
    .then(response => {
      dispatch({ type: UPDATED_ALARM, payload: response.data });
    })
    .catch(err => {
      dispatch({ type: UPDATING_ALARM_ERROR, payload: err })
    })
};