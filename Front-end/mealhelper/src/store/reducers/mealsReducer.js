import * as actionTypes from '../actions';

const initialState = {
  meals: [],
  gettingMeals: false,
  creatingMeal: false,
  updatingMeal: false,
  deletingMeal: false,
  singleMeal: {},
  error: ''
}

export const mealsReducer = (state = initialState, action) => {
  //switch cases
}