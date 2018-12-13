// == Dependencies == //
import React, { Component } from "react";
import { connect } from "react-redux";
import { withRouter } from "react-router-dom";
// == Actions == //
import {
  getMeals,
  changeMeal
} from "../../store/actions/mealActions";
// == Styles == //
import "./mealbook.css"

const meals = [
  {
    id: 1,
    user_id: 1,
    mealTime: "Breakfast",
    experience: "good",
    name: "Basic Morning Breakfast",
    temp: null,
    humidity: null,
    pressure: null,
    notes: "a delicious meal",
    date: "01/01/2018",
    servings: 1,
    recipe_id: 1,
  },
  {
    id: 2,
    user_id: 1,
    mealTime: "Lunch",
    experience: "",
    name: "Caramel Everything",
    temp: null,
    humidity: null,
    pressure: null,
    notes: "oof ouch owie my teeth",
    date: "01/01/2018",
    servings: 123,
    recipe_id: 2,
  }
];

const recipes = [
  {
    id: 1,
    name: "Eggs and Bacon",
    calories: 400,
    servings: 1,
    user_id: 1
  },
  {
    id: 2,
    name: "Caramel Popcorn",
    calories: 300,
    servings: 1,
    user_id: 1
  }
];

class MealBook extends Component {
  constructor(props) {
    super(props);
    this.state = {
      experience: ""
    }
  }

  componentDidMount() {

  }

  componentDidUpdate(prevProps) {

  }

  getNutrients(recipeID) {
   const recipe = recipes.find(recipe => recipe.id === recipeID);
    console.log("recipe", recipe, recipe.calories);
    return recipe.calories;
  }

  updateExperience(mealID, experience) {
    // changeMeal(mealID);
  }

  singleMealView(mealID) {
    this.props.history.push(`homepage/meals/mealbook/${mealID}`)
  }

  render() {
    return(
      <div className="mealbook-full-width">
      <div className="mealbook-container">
      <div className="mealbook-heading"><h1>Meals</h1></div>

      {meals.length ? meals.map(meal => (
        <div className="mealbook-card"
          key={meal.id}
          id={meal.id}
        >
        {" "}
        <br />
        <div className="mealbook-text">
        <div className="mealbook-card-sec1">
        <div className="mealbook-date"><p>{meal.date}</p></div>
        <div className="mealbook-time"><p>{meal.mealTime}</p></div>
        </div>
        <div className="mealbook-card-sec2">
        <div className="mealbook-name"><p>{meal.name}</p></div>
        <div className="mealbook-serve"><p>{meal.servings} servings</p></div>
        </div>
        </div>
        <div className="mealbook-nutr">
        <p>Calories: {this.getNutrients(meal.recipe_id)}</p>
        <p>Protein: 000</p>
        <p>Sugar: 000</p>
        <p>Sodium: 000</p>
        </div>
        <div className="mealbook-exp">
        <p>Experience:</p>
        <div className="mealbook-buttons">
          <button 
          className={meal.experience === "good" ? "mealbook-btn-active" : "mealbook-btn-inactive"} 
          onClick={() => console.log("GOOD")}>
          👍
          </button>
          <button 
          className={meal.experience === "bad" ? "mealbook-btn-active" : "mealbook-btn-inactive"} 
          onClick={() => console.log("BAD")}>
          👎 
          </button>
        </div>
        </div>
      </div>
      ))
      :
      <div className="meal-card empty">
      <div className="meal-text empty">You don't have any Meals.</div>
      </div>
    }
      </div>
      </div>
      )
    }
}

const mapStateToProps = state => ({
  meals: state.mealsReducer.meals,
  singleMeal: state.mealsReducer.meal,
  user: state.userReducer.user
});

export default connect(
  mapStateToProps,
  { getMeals, changeMeal }
)(withRouter(MealBook));
