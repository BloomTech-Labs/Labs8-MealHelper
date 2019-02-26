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
      servings: 1,
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
            <h1 className="new-recipe-text">Create A New Recipe</h1>
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
            <h4 className="servings-text">Servings: </h4>
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
