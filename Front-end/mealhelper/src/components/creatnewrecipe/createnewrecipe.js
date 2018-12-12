import React, { Component } from "react";
import { connect } from "react-redux";
//change the route for this
import axios from "axios";
import { addRecipe, getRecipe } from "../../store/actions/recipeActions.js";
import { getIngredients } from "../../store/actions/ingredActions";
import { withRouter, Link } from "react-router-dom";
import SearchFood from "./SearchFood";
import "../recipes/recipes.css";

class CreateNewRecipe extends Component {
  constructor(props) {
    super(props);

    this.state = {
      name: "",
      servings: null,
      query: "",
      ingredients: []
    };
  }

  componentDidMount() {
    if (localStorage.getItem("token")) {
      const id = localStorage.getItem("user_id");
      this.props.getRecipe(id);
      this.props.getIngredients(id);
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

  // handleSubmit = event => {
  //   event.preventDefault();
  //   const user_id = this.props.user.userID;
  //   const ingredient_id = this.state.ingredients.id;
  //   const { name, calories, servings } = this.state;
  //   const recipe = {
  //     user_id,
  //     ingredient_id,
  //     name,
  //     calories,
  //     servings
  //   };
  //   this.props.addRecipe(recipe);
  // };

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
              required
            />
            <input
              id="servings"
              className="servings-recipe"
              type="number"
              name="servings"
              onChange={this.handleChange}
              value={this.state.servings}
              placeholder="Servings. . ."
              required
            />

            <SearchFood name={this.state.name} servings={this.state.servings} />
          </div>
        </div>
      </div>
    );
  }
}

const mapStateToProps = state => {
  return {
    user: state.userReducer.user,
    recipe: state.recipesReducer.recipe,
    ingredients: state.ingredsReducer.ingredient
  };
};

export default connect(
  mapStateToProps,
  { addRecipe, getRecipe, getIngredients }
)(withRouter(CreateNewRecipe));
