import React, { Component } from "react";
import { connect } from "react-redux";
//change the route for this
import { addUser } from "../../store/actions/userActions";
import { withRouter, Link, Route } from "react-router-dom";
<<<<<<< HEAD
// import { Alert } from "reactstrap";
import axios from "axios";

=======
>>>>>>> 59f0eee0ddaded1d2cb51449611265731091aece
import "./recipes.css";
import CreateNewRecipe from "../creatnewrecipe/createnewrecipe";

class Recipes extends Component {
  state = {
    selectedFoods: []
  };
  componentDidMount() {
    if (localStorage.getItem("token")) {
    } else {
      this.props.history.push("/");
    }
  }

  render() {
    return (
      <div className="recipe-container">
        <Link className="recipe-link" to="/homepage/recipes/createnewrecipe">
          <div className="meal-box">
            <h1 className="new-meal-text">Create A New Recipe</h1>
          </div>
        </Link>
        <Link className="recipe-link2" to="/homepage/recipes/myrecipes">
          <div className="meal-box">
            <h1 className="new-meal-text">Recipe Book</h1>
          </div>
        </Link>
      </div>
    );
  }
}

const mapStateToProps = state => ({
  user: state.user
});

export default connect(
  mapStateToProps,
  { addUser }
)(withRouter(Recipes));
