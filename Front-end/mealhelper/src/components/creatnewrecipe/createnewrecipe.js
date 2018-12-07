import React, { Component } from "react";
import { connect } from "react-redux";
//change the route for this
import axios from "axios";
import { addRecipe, getRecipe } from "../../store/actions/recipeActions.js";
<<<<<<< HEAD
import { withRouter, Link } from "react-router-dom";
import SearchFood from "./SearchFood";
=======
import { withRouter } from "react-router-dom";
import Nutrients from "../recipes/Nutrients";
import FoodSearch from "../recipes/FoodSearch";
>>>>>>> 59f0eee0ddaded1d2cb51449611265731091aece
import "../recipes/recipes.css";

class CreateNewRecipe extends Component {
  constructor(props) {
    super(props);

    this.state = {
      query: ""
    };
  }

  componentDidMount() {
    if (localStorage.getItem("token")) {
      const id = localStorage.getItem("user_id");
      this.props.getRecipe(id);
    } else {
      this.props.history.push("/");
    }
  }

  handleChange = event => {
    event.preventDefault();
    this.setState({
      [event.target.name]: event.target.value
    });
  };

  handleSubmit = event => {
    event.preventDefault();
    const user_id = this.props.user.userID;
    const ingredient_id = this.state.ingredients.id;
    const { name, calories, servings } = this.state;
    const recipe = {
      user_id,
      ingredient_id,
      name,
      calories,
      servings
    };
    this.props.addRecipe(recipe);
  };

  removeFoodItem = itemIndex => {
    const filteredFoods = this.state.selectedFoods.filter(
      (item, idx) => itemIndex !== idx
    );
    this.setState({ selectedFoods: filteredFoods });
  };

  render() {
    return (
      <div className="recipe-container">
        <div className="new-recipe-holder">
          <form onSubmit={this.handleSubmit}>
            <div className="recipe-input-1">
              <h1 className="new-meal-text-new">Create A New Recipe</h1>
              <input
                id="name"
                className="name-recipe"
                type="text"
                name="name"
                onChange={this.handleChange}
                value={this.state.name}
                placeholder="Recipe Name"
              />

              <SearchFood />
            </div>
          </form>
        </div>
      </div>
    );
  }
}

const mapStateToProps = state => {
  return {
    user: state.userReducer.user,
    recipe: state.recipesReducer.recipe
  };
};

export default connect(
  mapStateToProps,
  { addRecipe, getRecipe }
)(withRouter(CreateNewRecipe));
