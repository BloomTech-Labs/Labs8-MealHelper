import React, { Component } from "react";
import { connect } from "react-redux";
//change the route for this
import { addUser } from "../../store/actions/userActions";
import { withRouter, Link, Route } from "react-router-dom";
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
    return <CreateNewRecipe />;
  }
}

const mapStateToProps = state => ({
  user: state.user
});

export default connect(
  mapStateToProps,
  { addUser }
)(withRouter(Recipes));
