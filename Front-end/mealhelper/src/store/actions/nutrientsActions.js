import axios from "axios";

//Ingredient
export const ADDING_NUTRIENT = "ADDING_INGREDIENT";
export const ADDED_NUTRIENT = "ADDED_INGREDIENT";
export const ADDING_NUTRIENT_ERROR = "ADDING_INGREDIENT_ERROR";
export const GETTING_NUTRIENT = "GETTING_INGREDIENT";
export const GOT_NUTRIENT = "GOT_INGREDIENT";
export const GETTING_NUTRIENT_ERROR = "GETTING_INGREDIENT_ERROR";

//Route to sign up a user
export const addMultipleNutrients = (nutrient, userID) => dispatch => {
  for (let i = 0; i < nutrient.length; i++) {
    dispatch({ type: ADDING_NUTRIENT });
    const id = userID;
    console.log(id);
    console.log(nutrient);
    const promise = axios.post(
      `https://labs8-meal-helper.herokuapp.com/nutrients/${id}`,
      nutrient[i]
    );
    promise
      .then(response => {
        dispatch({ type: ADDED_NUTRIENT, payload: response.data });
      })
      .catch(err => {
        dispatch({ type: ADDING_NUTRIENT_ERROR, payload: err });
      });
  }
};
export const getMultipleNutrients = (ingredient, userId) => dispatch => {
  for (let i = 0; i < ingredient.length; i++) {
    dispatch({ type: GETTING_NUTRIENT });
    const id = userId;
    console.log(id);
    console.log(ingredient);
    //Needs to grab them from the ingredient
    const promise = axios.post(
      `https://labs8-meal-helper.herokuapp.com/ingredients/${id}`,
      ingredient[i]
    );
    promise
      .then(response => {
        dispatch({ type: GOT_NUTRIENT, payload: response.data });
      })
      .catch(err => {
        dispatch({ type: GETTING_NUTRIENT_ERROR, payload: err });
      });
  }
};
