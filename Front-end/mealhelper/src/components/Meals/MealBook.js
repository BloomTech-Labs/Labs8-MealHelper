// == Dependencies == //
import React, { Component } from "react";
import { connect } from "react-redux";
import { withRouter } from "react-router-dom";
// == Actions == //
import {
  getMeals
} from "../../store/actions/mealActions";
// == Styles == //

const meals = [];

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