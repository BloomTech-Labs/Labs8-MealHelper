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
