import axios from "axios";

//Ingredient
export const ADDING_RECIPE = "ADDING_RECIPE";
export const ADDED_RECIPE = "ADDED_RECIPE";
export const ADDING_RECIPE_ERROR = "ADDING_RECIPE_ERROR";
export const ADDING_RECIPES = "ADDING_RECIPES";
export const ADDED_RECIPES = "ADDED_RECIPES";
export const ADDING_RECIPE_ERRORS = "ADDING_RECIPE_ERRORS";
export const GETTING_RECIPE = "GETTING_RECIPE";
export const GOT_RECIPE = "GOT_RECIPE";
export const GETTING_RECIPE_ERROR = "GETTING_RECIPE_ERROR";
export const GETTING_RECIPES = "GETTING_RECIPE";
export const GOT_RECIPES = "GOT_RECIPE";
export const GETTING_RECIPE_ERRORS = "GETTING_RECIPE_ERROR";
export const PUTTING_RECIPE = "PUTTING_RECIPE";
export const PUT_RECIPE = "PUT_RECIPE";
export const PUTTING_RECIPE_ERROR = "PUTTING_RECIPE_ERROR";
export const DELETING_RECIPE = "DELETING_RECIPE";
export const DELETED_RECIPE = "DELETED_RECIPE";
export const DELETING_RECIPE_ERROR = "DELETING_RECIPE_ERROR";

//Route to sign up a recipes
export const addRecipe = (recipe, userID) => dispatch => {
  dispatch({ type: ADDING_RECIPE });
  const userId = userID;
  console.log(recipe);
  const promise = axios.post(
    `https://labs8-meal-helper.herokuapp.com/recipe/${userId}`,
    recipe
  );
  promise
    .then(response => {
      dispatch({ type: ADDED_RECIPE, payload: response.data });
    })
    .catch(err => {
      dispatch({ type: ADDING_RECIPE_ERROR, payload: err });
    });
};
//Route to login a user
// export const getMeals = id => dispatch => {
// 	dispatch({ type: GETTING_MEALS });

// 	axios

// 		.get(`https://labs8-meal-helper.herokuapp.com/ingredients/${id}`)
// 		.then(response => {
// 			dispatch({ type: GOT_MEALS, payload: response.data });
// 		})
// 		.catch(err => {
// 			dispatch({ type: GETTING_MEAL_ERRORS, payload: err });
// 		});
// };

//Route to Get Specific Users Recipes
export const getRecipe = id => dispatch => {
  dispatch({ type: GETTING_RECIPES });
  axios

    .get(`https://labs8-meal-helper.herokuapp.com/recipe/user/${id}`)
    .then(response => {
      dispatch({ type: GOT_RECIPE, payload: response.data });
    })
    .catch(err => {
      dispatch({ type: GETTING_RECIPE_ERROR, payload: err });
    });
};

export const changeRecipe = recipe => dispatch => {
  dispatch({ type: PUTTING_RECIPE });
  const recipeID = recipe.recipeID;
  axios

    .put(`https://labs8-meal-helper.herokuapp.com/recipe/${recipeID}`, recipe)
    .then(response => {
      dispatch({ type: PUT_RECIPE, payload: response.data });
    })
    .catch(err => {
      dispatch({ type: PUTTING_RECIPE_ERROR, payload: err });
    });
};
export const deleteRecipe = id => dispatch => {
  dispatch({ type: DELETING_RECIPE });
  const recipeID = id.recipeID;
  // const user_id = id.userID;
  axios

    .delete(`https://labs8-meal-helper.herokuapp.com/recipe/${recipeID}`)
    .then(response => {
      dispatch({ type: DELETED_RECIPE, payload: response.data });
    })
    .catch(err => {
      dispatch({ type: DELETING_RECIPE_ERROR, payload: err });
    });
};
