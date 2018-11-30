import React, { Component } from "react";
import axios from "axios";
import { connect } from "react-redux";
import "../homepage/homepage.css";

//change the route for this
import { addUser } from "../../store/actions/userActions";
import { withRouter, Link, Route, Switch } from "react-router-dom";
import { Alert } from "reactstrap";
import Weather from "../weather/weather";
import Recipes from "../recipes/recipes";
import Meals from "../Meals/Meals";
import CreateNewRecipe from "../creatnewrecipe/createnewrecipe";
import AddAlarms from "../alarms/addAlarm";
import MyAlarms from "../alarms/myAlarms";
import {
  Button,
  Modal,
  ModalHeader,
  ModalBody,
  ModalFooter,
  UncontrolledDropdown,
  DropdownToggle,
  DropdownMenu,
  DropdownItem
} from "reactstrap";
import { Elements, StripeProvider } from "react-stripe-elements";
import CheckoutForm from "../checkout/CheckoutForm";
import Billing from "../billing/billing";

class MealDisplay extends Component {
  handleChange = event => {
    event.preventDefault();
    this.setState({
      [event.target.name]: event.target.value
    });
  };

  createUser = event => {
    event.preventDefault();
    if (!this.state.email || !this.state.password) {
      this.setState({ visable: true });
    } else {
      const { email, password, zip, healthCondition } = this.state;
      const user = { email, password, zip, healthCondition };
      this.props.addUser(user);
      // this.props.history.push("/");
    }
  };

  render() {
    return (
      <div className="MealDisplay">
        <div className="meal-card-header">
          <p className="meal-experience">{this.props.experience}</p>
        </div>
        <div className="meal-card-center">
          <h1 className="meal-time">{this.props.mealTime}</h1>
          <h4 className="meal-date">{this.props.date}</h4>
        </div>

        <div className="meal-card-footer">
          <h5 className="meal-city">{this.props.city}</h5>
          <h5 className="meal-temp">{this.props.temp} &#176;F</h5>
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
)(withRouter(MealDisplay));
