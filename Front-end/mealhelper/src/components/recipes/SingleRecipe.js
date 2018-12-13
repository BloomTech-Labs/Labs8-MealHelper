import React, { Component } from "react";
import { connect } from "react-redux";
//change the route for this
import { addUser } from "../../store/actions/userActions";
import { withRouter, Link, Route } from "react-router-dom";
import { getRecipe, deleteRecipe } from "../../store/actions/recipeActions";
// import { Alert } from "reactstrap";
import axios from "axios";

import "./recipes.css";

class SingleRecipe extends Component {
  state = {
    recipe: [],
    ingredients: [],
    nutrition: []
  };
  componentDidMount() {
    if (localStorage.getItem("token")) {
      console.log(this.props);
      axios
        .get(
          `https://labs8-meal-helper.herokuapp.com/recipe/single/${
            this.props.match.params.id
          }`
        )
        .then(response => {
          console.log(response);
        });
    } else {
      this.props.history.push("/");
    }
  }

  render() {
    return (
      <div className="single-recipe-container">
        <h1>Single Recipe View</h1>
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
  { addUser, deleteRecipe, getRecipe }
)(withRouter(SingleRecipe));
