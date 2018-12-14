import React, { Component } from "react";
import { connect } from "react-redux";
//change the route for this
import { addUser } from "../../store/actions/userActions";
import { withRouter, Link } from "react-router-dom";
import { getIngredients } from "../../store/actions/ingredActions";
import { deleteRecipe } from "../../store/actions/recipeActions";

import "./recipes.css";

class Recipe extends Component {
  render() {
    return (
      <Link recipeID={this.props.id} to={`/recipe/${this.props.id}`}>
        <div className="single-recipe-view">
          <div className="recipe-name">
            <h1>{this.props.name}</h1>
          </div>
          <div className="calories-display">
            Calories: {this.props.calories}
          </div>
          <button
            onClick={() =>
              this.props.deleteRecipe(
                this.props.id,
                localStorage.getItem("user_id")
              )
            }
            className="delete-recipe"
          >
            Delete
          </button>
        </div>
      </Link>
    );
  }
}

const mapStateToProps = state => ({
  user: state.user
});

export default connect(
  mapStateToProps,
  { addUser, deleteRecipe }
)(withRouter(Recipe));
