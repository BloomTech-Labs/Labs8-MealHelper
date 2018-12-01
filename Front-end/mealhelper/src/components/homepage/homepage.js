import React, { Component } from "react";
import axios from "axios";
import { connect } from "react-redux";
import "./homepage.css";
// import MealDisplay from "../display/MealDisplay.js";
// import RecipeDisplay from "../display/RecipeDisplay.js";
//change the route for this
import { addUser } from "../../store/actions/userActions";
import { withRouter } from "react-router-dom";
// import { Alert } from "reactstrap";
// import Weather from "../weather/weather";
// import Recipes from "../recipes/recipes";
// import Meals from "../Meals/Meals";
// import CreateNewRecipe from "../creatnewrecipe/createnewrecipe";
// import AddAlarms from "../alarms/addAlarm";
// import MyAlarms from "../alarms/myAlarms";
// import {
//   Button,
//   Modal,
//   ModalHeader,
//   ModalBody,
//   ModalFooter,
//   UncontrolledDropdown,
//   DropdownToggle,
//   DropdownMenu,
//   DropdownItem
// } from "reactstrap";
// import { Elements, StripeProvider } from "react-stripe-elements";
// import CheckoutForm from "../checkout/CheckoutForm";
// import Billing from "../billing/billing";
import SideBar from "../sidebar/sidebar";
import Display from "../display/display";

class HomePage extends Component {
  constructor(props) {
    super(props);

    this.state = {
      email: "",
      password: "",
      zip: null,
      healthCondition: "",
      visable: false,
      modal: false,
      meals: [],
      recipes: []
    };
  }

  componentDidMount = () => {
    if (localStorage.getItem("token")) {
      const id = localStorage.getItem("user_id");
      console.log(id);
      axios
        .get(`https://labs8-meal-helper.herokuapp.com/recipe/user/${id}`)
        .then(recipess => {
          this.setState({ recipes: recipess.data });
        })
        .catch(err => {
          console.log(err);
        });
      this.componentGetMeals();
    } else {
      this.props.history.push("/");
    }
  };

  componentGetMeals() {
    const id = localStorage.getItem("user_id");
    console.log(id);
    axios
      .get(`https://labs8-meal-helper.herokuapp.com/users/${id}/meals`)
      .then(meals => {
        console.log(meals);
        this.setState({ meals: meals.data });
      })
      .catch(err => {
        console.log(err);
      });
    console.log(this.state.meals);
  }

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
  toggle = () => {
    this.setState({
      modal: !this.state.modal
    });
  };

  logout = event => {
    event.preventDefault();
    localStorage.removeItem("token");
    localStorage.removeItem("user_id");
    this.props.history.push("/");
  };

  render() {
    return (
      <div className="home-container-home">
        <SideBar />
        <Display />
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
)(withRouter(HomePage));