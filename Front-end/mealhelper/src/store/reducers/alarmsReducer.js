/* Alarms Reducer */
import * as actionTypes from '../actions';
import axios from 'axios';

const initialState = {
  alarms: [],
  fetchingAlarms: false,
  addingAlarms: false,
  updatingAlarm: false,
  deletingAlarm: false,
  error: null
};

export const alarmsReducer = (state = initialState, action) => {
  switch (action.type) {
    case FETCHING_ALARMS:
      return {...state, fetchingAlarms: true };
    case FETCHED_ALARMS:
      return {...state, fetchingAlarms: false, alarms: action.payload }
    case ALARMS_FETCHING_ERROR:
      return {...state, fetchingAlarms: false, error: action.payload}
    case ADDING_ALARMS:
      return {...state, addingAlarms: true };
    case ADDED_ALARMS:
      return {...state, addingAlarms: false};
    case ADDING_ALARMS_ERROR:
      return {...state, addingAlarms: false, error: action.payload};
  }
}