import React, { Component } from "react";
import { connect } from "react-redux";
//change the route for this
import { addMeal } from "../../store/actions/mealActions";
import { withRouter, Link, Route } from "react-router-dom";
// import { Alert } from "reactstrap";
import "./meals.css";

class Meals extends Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div className="meals-container">
        <Link className="meal-link" to="/homepage/meals/new">
          <div className="meal-box">
            <h1 className="new-meal-text">Create A New Meal</h1>
          </div>
        </Link>
      </div>
    );
  }
}

const mapStateToProps = state => ({
  user: state.userReducer.user,
  meals: state.mealsReducer.meals,
  recipes: state.recipesReducer.recipes
});

export default connect(
  mapStateToProps,
  { addMeal }
)(withRouter(Meals));
