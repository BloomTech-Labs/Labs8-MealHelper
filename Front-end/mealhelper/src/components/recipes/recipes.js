import React, { Component } from "react";
import { connect } from "react-redux";
//change the route for this
import { addUser } from "../../store/actions/userActions";
import { withRouter } from "react-router-dom";
// import { Alert } from "reactstrap";
// import axios from "axios";
// import Recipe from "./recipe";
// import SelectedFoods from "./SelectedFoods";
// import FoodSearch from "./FoodSearch";
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
