import React, { Component } from "react";
import { connect } from "react-redux";
//change the route for this
import { getMeals } from "../../store/actions/mealActions.js";
import { getRecipe } from "../../store/actions/recipeActions";
import { withRouter, Link, Route } from "react-router-dom";
// import { Alert } from "reactstrap";
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
      ndbno: null
    };
  }
  componentDidMount() {
    if (localStorage.getItem("token")) {
      const id = localStorage.getItem("user_id");
      this.props.getRecipe(id);

      this.setState({ list: this.props.recipes });
    } else {
      this.props.history.push("/");
    }
  }
  componentWillReceiveProps(nextProps) {
    this.setState({ list: nextProps.meals });
  }

  handleChange = event => {
    event.preventDefault();
    this.setState({
      [event.target.name]: event.target.value
    });
  };

  render() {
    return (
      <div className="weather-container">
        <div className="home-container">
          <div className="recipe-book">
            {this.props.recipes.map(item => (
              <Recipe
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
  console.log(state);
  return {
    user: state.userReducer.user,
    meals: state.mealsReducer.meals,
    recipes: state.recipesReducer.recipes
  };
};

export default connect(
  mapStateToProps,
  { getMeals, getRecipe }
)(withRouter(MyRecipes));
