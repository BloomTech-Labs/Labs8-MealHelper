import axios from "axios";

//Ingredient
export const ADDING_NUTRIENT = "ADDING_NUTRIENT";
export const ADDED_NUTRIENT = "ADDED_NUTRIENT";
export const ADDING_NUTRIENT_ERROR = "ADDING_NUTRIENT_ERROR";
export const GETTING_NUTRIENT = "GETTING_NUTRIENT";
export const GOT_NUTRIENT = "GOT_NUTRIENT";
export const GETTING_NUTRIENT_ERROR = "GETTING_NUTRIENT_ERROR";

//Route to sign up a user
export const addMultipleNutrients = (
  nutrient,
  userID,
  count,
  recipe_id
) => dispatch => {
  for (let i = 0; i < count; i++) {
    for (let j = 0; j < 4; j++) {
      dispatch({ type: ADDING_NUTRIENT });
      const id = userID;
      nutrient[i]["recipe_id"] = recipe_id;
      console.log("This is what is posting at this second", nutrient[i][j]);
      const promise = axios.post(
        `https://labs8-meal-helper.herokuapp.com/nutrients/${id}`,
        nutrient[i][j]
      );
      promise
        .then(response => {
          dispatch({ type: ADDED_NUTRIENT, payload: response.data });
        })
        .catch(err => {
          dispatch({ type: ADDING_NUTRIENT_ERROR, payload: err });
        });
    }
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
