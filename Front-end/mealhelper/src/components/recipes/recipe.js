import React, { Component } from "react";
import { connect } from "react-redux";
//change the route for this
import { addMeal } from "../../store/actions/mealActions.js";
import { withRouter } from "react-router-dom";
// import { Alert } from "reactstrap";
// import axios from "axios";
import "./recipes.css";

class Recipe extends Component {
  constructor(props) {
    super(props);

    this.state = {
      name: "",
      ndbno: null
    };
  }

  componentDidMount() {
    this.setState({ name: this.props.item.name, ndbno: this.props.item.ndbno });
  }

  saveItem = event => {
    event.preventDefault();
    console.log(this.props);
    const user_id = this.props.user.userID;
    console.log(user_id);
    const { name, ndbno } = this.state;

    const meal = { name, ndbno, user_id };
    console.log(meal);
    this.props.addMeal(meal);
    this.props.history.push("/homepage");
  };

  handleChange = event => {
    event.preventDefault();
    this.setState({
      [event.target.name]: event.target.value
    });
  };

  render() {
    return (
      <div className="weather-container">
        <button onClick={this.saveItem}>Name: {this.props.item.name}</button>
      </div>
    );
  }
}

const mapStateToProps = state => {
  return {
    user: state.userReducer.user,
    ingredient: state.ingredient
  };
};

export default connect(
  mapStateToProps,
  { addMeal }
)(withRouter(Recipe));
