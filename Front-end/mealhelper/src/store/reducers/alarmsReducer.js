/* Alarms Reducer */
import * as actionTypes from '../actions';
import { 
  FETCHING_ALARMS,
  FETCHED_ALARMS,
  FETCHING_ALARMS_ERROR,
  FETCHING_SINGLE_ALARM,
  FETCHED_SINGLE_ALARM,
  FETCHING_SINGLE_ALARM_ERROR,
  ADDING_ALARMS,
  ADDED_ALARMS,
  ADDING_ALARMS_ERROR,
  UPDATING_ALARM,
	UPDATED_ALARM,
	UPDATING_ALARM_ERROR,
	DELETING_ALARM,
	DELETED_ALARM,
	DELETING_ALARM_ERROR
} from '../actions/alarmActions';
import axios from 'axios';

const initialState = {
  alarms: [],
  alarm: {},
  fetchingAlarms: false,
  fetchingSingleAlarm: false,
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
    case FETCHING_ALARMS_ERROR:
      return {...state, fetchingAlarms: false, error: action.payload}
      case FETCHING_SINGLE_ALARM:
      return {...state, fetchingSingleAlarm: true };
    case FETCHED_SINGLE_ALARM:
      return {...state, fetchingSingleAlarm: false, alarms: action.payload }
    case FETCHING_SINGLE_ALARM_ERROR:
      return {...state, fetchingSingleAlarm: false, error: action.payload}
    case ADDING_ALARMS:
      return {...state, addingAlarms: true };
    case ADDED_ALARMS:
      return {...state, addingAlarms: false, alarms: action.payload };
    case ADDING_ALARMS_ERROR:
      return {...state, addingAlarms: false, error: action.payload};
      case UPDATING_ALARM:
			return { ...state, updatingAlarm: true };
		case UPDATED_ALARM:
			return { ...state, updatingAlarm: false, alarm: action.payload };
		case UPDATING_ALARM_ERROR:
			return { ...state, updatingAlarm: false, error: action.payload };
    case DELETING_ALARM:
			return { ...state, deletingAlarm: true };
		case DELETED_ALARM:
			return { ...state, deletingAlarm: false, notes: action.payload };
		case DELETING_ALARM_ERROR:
			return { ...state, deletingAlarm: false, error: action.payload };
      default:
      return state;
  }
}