import React, { Component } from "react";
import { connect } from "react-redux";
//change the route for this
import { getMeals } from "../../store/actions/mealActions.js";
import { getRecipe, deleteRecipe } from "../../store/actions/recipeActions";
import { withRouter, Link, Route } from "react-router-dom";
import { Alert } from "reactstrap";
import axios from "axios";
import Recipe from "./recipe";

import "./recipes.css";

class MyRecipes extends Component {
  constructor(props) {
    super(props);

    this.state = {
      list: [],
      search: "",
      name: "",
      ndbno: null,
      visable: false
    };
  }
  componentDidMount() {
    if (localStorage.getItem("token")) {
      const id = localStorage.getItem("user_id");
      this.props.getRecipe(id);
      axios

        .get(`https://labs8-meal-helper.herokuapp.com/recipe/user/${id}`)
        .then(response => {
          console.log(response);
          this.setState({ list: response.data });
        })
        .catch(err => {
          console.log(err);
        });
    } else {
      this.props.history.push("/");
    }
  }
  componentDidUpdate(prevState) {
    console.log(prevState);

    console.log(this.state.list);
    if (this.props.recipes.length !== this.state.list.length) {
      const id = localStorage.getItem("user_id");
      axios

        .get(`https://labs8-meal-helper.herokuapp.com/recipe/user/${id}`)
        .then(response => {
          this.setState({ list: response.data });
        })
        .catch(err => {
          console.log(err);
        });
    }
  }

  deleteRecipe = (id, userid) => {
    console.log(userid);

    this.props.deleteRecipe(id, userid);
  };
  render() {
    return (
      <div className="recipe-div-container">
        <div className="recipe-container">
          <div className="recipe-book">
            {this.state.list.map(item => (
              <Recipe
                deleteRecipe={this.deleteRecipe}
                id={item.id}
                item={item}
                calories={item.calories}
                key={item.ndbno}
                name={item.name}
                ndbno={item.ndbno}
              />
            ))}
          </div>
        </div>
      </div>
    );
  }
}

const mapStateToProps = state => {
  return {
    user: state.userReducer.user,
    meals: state.mealsReducer.meals,
    recipes: state.recipesReducer.recipes
  };
};

export default connect(
  mapStateToProps,
  { getMeals, getRecipe, deleteRecipe }
)(withRouter(MyRecipes));
