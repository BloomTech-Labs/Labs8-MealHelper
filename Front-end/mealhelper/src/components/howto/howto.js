import React, { Component } from "react";
import { connect } from "react-redux";
import "./howto.css";
import { addUser } from "../../store/actions/userActions";
import { withRouter, Link } from "react-router-dom";

import { Router, Route } from "react-router";

class HowTo extends Component {
  render() {
    return (
      <div>
        <h1 className="get-started-cta">Get Started!</h1>
        <div class="inapp-choice-wrapper">
          <div class="box recipes">
            Step 1: Recipes
            <br />
            <p className="recipes-text">
              It all starts with the recipe. Click recipe and start adding your
              ingredients!
            </p>
          </div>
          <div class="box meals">
            Step 3: Meals <br />
            <p className="meals-text">
              Then name your meal and add the recipe.
            </p>
          </div>
          <div class="box ingredients">
            Step 2: Ingredients <br />
            <p className="ingredients-text">
              From your recipe modal, enter your ingredients and save them.
            </p>
          </div>
          <div class="box alarms">
            Step 4: Alarms
            <br />
            <p className="alarms-text">
              And last, set your alarms to remind you to eat.
            </p>
          </div>
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
)(withRouter(HowTo));
