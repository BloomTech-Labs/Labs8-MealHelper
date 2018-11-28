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

// export const alarmsReducer = (state = initialState, action) => {
//   //switch cases
// }