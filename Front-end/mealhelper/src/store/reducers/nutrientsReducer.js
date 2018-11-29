import {
  ADDING_NUTRIENT,
  ADDED_NUTRIENT,
  ADDING_NUTRIENT_ERROR,
  GETTING_NUTRIENT,
  GOT_NUTRIENT,
  GETTING_NUTRIENT_ERROR
} from "../actions/nutrientsActions";

/* Recipes Reducer */

const initialState = {
  nutrients: [],
  addingNutrients: false,
  gettingNutrients: false,
  error: ""
};

export const nutrientsReducer = (state = initialState, action) => {
  switch (action.type) {
    case ADDING_NUTRIENT:
      //Initial adding recipe
      return { ...state, addingNutrients: true };
    case ADDED_NUTRIENT:
      //Returns the recipe ID
      return {
        ...state,
        addingNutrients: false,
        nutrients: [...this.state.nutrients, action.payload]
      };
    case ADDING_NUTRIENT_ERROR:
      //Shoots off if there is an error creating a new recipe
      return { ...state, addingNutrients: false, error: action.payload };
    case GETTING_NUTRIENT:
      //Initial adding recipe
      return { ...state, addingRecipe: true };
    case GOT_NUTRIENT:
      //Returns the recipe ID
      return {
        ...state,
        addingRecipe: false,
        nutrients: action.payload
      };
    case GETTING_NUTRIENT_ERROR:
      //Shoots off if there is an error creating a new recipe
      return { ...state, addingRecipe: false, error: action.payload };
    default:
      return state;
  }
};
