import React, { Component } from "react";
import { connect } from "react-redux";
//change the route for this
import { addUser } from "../../store/actions/userActions";
import { withRouter, Link } from "react-router-dom";
import { getIngredients } from "../../store/actions/ingredActions";

import "./recipes.css";

class Recipe extends Component {
  render() {
    return (
      <Link to={`/recipe/${this.props.id}`}>
        <div className="single-recipe-view">
          <div>
            <h1>{this.props.name}</h1>
          </div>
          <div className="ingredients-display">
            Calories: {this.props.calories}
          </div>
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
  { addUser }
)(withRouter(Recipe));
