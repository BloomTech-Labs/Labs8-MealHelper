import {
  ADDING_RECIPES,
  ADDED_RECIPES,
  ADDING_RECIPE_ERRORS,
  ADDING_RECIPE,
  ADDED_RECIPE,
  ADDING_RECIPE_ERROR,
  GETTING_RECIPE,
  GOT_RECIPE,
  GETTING_RECIPE_ERROR,
  GETTING_RECIPES,
  GOT_RECIPES,
  GETTING_RECIPE_ERRORS,
  PUTTING_RECIPE,
  PUT_RECIPE,
  PUTTING_RECIPE_ERROR,
  DELETING_RECIPE,
  DELETED_RECIPE,
  DELETING_RECIPE_ERROR
} from "../actions/recipeActions";

/* Recipes Reducer */

const initialState = {
  recipes: [],
  singleRecipe: [],
  gettingRecipes: false,
  gettingRecipe: false,
  addingRecipe: false,
  updatingRecipe: false,
  deletingRecipe: false,
  error: ""
};

export const recipesReducer = (state = initialState, action) => {
  switch (action.type) {
    case ADDING_RECIPE:
      //Initial adding recipe
      return { ...state, addingRecipe: true };
    case ADDED_RECIPE:
      //Returns the recipe ID
      return {
        ...state,
        addingRecipe: false,
        singleRecipe: action.payload,
        recipes: action.payload
      };
    case ADDING_RECIPE_ERROR:
      //Shoots off if there is an error creating a new recipe
      return { ...state, addingRecipe: false, error: action.payload };
    case GETTING_RECIPE:
      return { ...state, gettingRecipe: true };
    case GOT_RECIPE:
      return {
        ...state,
        gettingRecipe: false,
        recipes: action.payload
      };
    case GETTING_RECIPE_ERROR:
      return { ...state, gettingRecipe: false, error: action.payload };
    case PUTTING_RECIPE:
      //Deleting a recipe
      return { ...state, updatingRecipe: true };
    case PUT_RECIPE:
      //Returns a 1 if deleted and sets that in the user array (front end check for that)
      return { ...state, updatingRecipe: false, meals: action.payload };
    case PUTTING_RECIPE_ERROR:
      //Shoots off if there is an error deleting a recipe
      return { ...state, updatingRecipe: false, error: action.payload };

    case DELETING_RECIPE:
      //Initial updating of a recipe
      return { ...state, deletingRecipe: true };
    case DELETED_RECIPE:
      //Returns the recipe
      return { ...state, deletingRecipe: false, meals: action.payload };
    case DELETING_RECIPE_ERROR:
      //Shoots off if there is an error updating a recipe
      return { ...state, deletingRecipe: false, error: action.payload };
    default:
      return state;
  }
};
