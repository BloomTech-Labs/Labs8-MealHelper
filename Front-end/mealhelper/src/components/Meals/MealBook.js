// == Dependencies == //
import React, { Component } from "react";
import { connect } from "react-redux";
import { withRouter } from "react-router-dom";
// == Actions == //
import {
  getMeals
} from "../../store/actions/mealActions";
// == Styles == //

const meals = [
  {
    id: 1,
    user_id: 1,
    mealTime: "Breakfast",
    experience: "👍",
    name: "",
    temp: null,
    humidity: null,
    pressure: null,
    notes: "a delicious meal",
    date: "01/01/2018",
    servings: 1,
    recipe_id: 1,
  }
];

const recipes = [
  {
    id: 1,
    name: "Eggs and Bacon",
    calories: 400,
    servings: 1,
    user_id: 1
  }
];

class MealBook extends Component {
  constructor(props) {
    super(props);
  }

  componentDidMount() {

  }

  componentDidUpdate(prevProps) {

  }

  render() {
    return(
      <div className="meals-full-width">
      <div className="meals-container">
      <div className="meals-heading"><h1>Meals</h1></div>

      {meals.length ? meals.map(meal => (
        <div className="meal-card"
          key={meal.id}
          id={meal.id}
        >
        {" "}
        <br />
        <div className="meal-text">
        <div className="meal-date"><p>{meal.date}</p></div>
        <div className="meal-serve"><p>{meal.servings}</p></div>
        <div className="meal-name"><p>{meal.name}</p></div>
        <div className="meal-time"><p>{meal.mealTime}</p></div>
        <div className="meal-exp"><p>{meal.experience}</p></div>
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
  { getMeals }
)(withRouter(MealBook));
