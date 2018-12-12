import React, { Component } from "react";

import { connect } from "react-redux";
// import "../homepage/homepage.css";

import "./RecipeDisplay.css";

//change the route for this
import { addUser } from "../../store/actions/userActions";
import { withRouter } from "react-router-dom";

class RecipeDisplay extends Component {
  handleChange = event => {
    event.preventDefault();
    this.setState({
      [event.target.name]: event.target.value
    });
  };

  render() {
    return (
      <div className="RecipeDisplay">
        <div className="recipe-card-header">
          <p className="recipe-experience">Servings: {this.props.servings}</p>
          <p className="recipe-experience">{this.props.calories} Calories</p>
        </div>
        <div className="recipe-card-center">
          <h1 className="recipe-time">{this.props.name}</h1>
        </div>
      </div>
    );
  }
}

const mapStateToProps = state => ({
  user: state.userReducer.user,
  meals: state.mealsReducer.meals
});

export default connect(
  mapStateToProps,
  { addUser }
)(withRouter(RecipeDisplay));
