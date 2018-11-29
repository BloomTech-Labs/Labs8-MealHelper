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
    case actionTypes.FETCHING_ALARMS:
      return {...state, fetchingAlarms: true };
    case actionTypes.FETCHED_ALARMS:
      return {...state, fetchingAlarms: false, alarms: action.payload }
    case actionTypes.FETCHING__ALARMS_ERROR:
      return {...state, fetchingAlarms: false, error: action.payload}
    case actionTypes.ADDING_ALARMS:
      return {...state, addingAlarms: true };
    case actionTypes.ADDED_ALARMS:
      return {...state, addingAlarms: false, alarms: action.payload };
    case actionTypes.ADDING_ALARMS_ERROR:
      return {...state, addingAlarms: false, error: action.payload};
      case actionTypes.UPDATING_ALARM:
			return { ...state, updatingAlarm: true };
		case actionTypes.UPDATED_ALARM:
			return { ...state, updatingAlarm: false, alarms: action.payload };
		case actionTypes.UPDATING_ALARM_ERROR:
			return { ...state, updatingAlarm: false, error: action.payload };
      case actionTypes.DELETING_ALARM:
			return { ...state, deletingAlarm: true };
		case actionTypes.DELETED_ALARM:
			return { ...state, deletingAlarm: false, notes: action.payload };
		case actionTypes.DELETED_ALARM_ERROR:
			return { ...state, deletingAlarm: false, error: action.payload };
      default:
      return state;
  }
}