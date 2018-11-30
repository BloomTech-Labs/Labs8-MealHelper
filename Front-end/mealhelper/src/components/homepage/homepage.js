import React, { Component } from "react";
import axios from "axios";
import { connect } from "react-redux";
import "./homepage.css";
import MealDisplay from "./MealDisplay.js";
import RecipeDisplay from "./RecipeDisplay.js";
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
      const id = this.props.user.userID;
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
    console.log(this.state.recipes);
    const id = this.props.user.userID;
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
    this.props.history.push("/");
  };

  render() {
    return (
      <div className="home-container-home">
        <div className="sidebar">
          <Link to="/homepage" style={{ textDecoration: "none" }}>
            <h2 className="titlelinks">Home</h2>
          </Link>
          <Link to="/homepage/recipes" style={{ textDecoration: "none" }}>
            <h2 className="titlelinks">Recipes</h2>
          </Link>
          <Link to="/homepage/alarms" style={{ textDecoration: "none" }}>
            <h2 className="titlelinks">Alarms</h2>
          </Link>
          <Link to="/homepage/meals" style={{ textDecoration: "none" }}>
            <h2 className="titlelinks">Meals</h2>
          </Link>
          <Link to="/homepage/billing" style={{ textDecoration: "none" }}>
            <h2 className="titlelinks">Billing</h2>
          </Link>
          <Link to="/homepage/settings" style={{ textDecoration: "none" }}>
            <h2 className="titlelinks">Settings</h2>
          </Link>
          <Button color="danger" onClick={this.toggle}>
            Log Out
          </Button>
          <Link to="homepage/billing">
            <Button className="danger" color="danger">
              Upgrade to Premium
            </Button>
          </Link>
          {/* <StripeProvider apiKey="pk_test_rMbD3kGkxVoOsMd0meVqUlmG">
            <div className="example">
              <h1>Pay Up Health Nut</h1>
              <Elements>
                <CheckoutForm />
              </Elements>
            </div>
          </StripeProvider> */}
        </div>
        <div className="flex-me">
          <div className="dynamic-display-home-meals">
            <p className="recentMeals">4 Most Recently Made Meals: </p>
          </div>
          <div className="dynamic-display-home">
            <div className="mealsRecipe-Container">
              <div>
                <div className="mealDisplay-Flex">
                  {this.state.meals
                    .reverse()
                    .slice(0, 4)

                    .map(meal => (
                      <MealDisplay
                        key={meal.id}
                        meal={meal}
                        mealTime={meal.mealTime}
                        temp={meal.temp}
                        experience={meal.experience}
                        date={meal.date}
                        city={meal.name}
                      />
                    ))}
                </div>
              </div>
            </div>
          </div>
          <div className="dynamic-display-home-meals">
            <p className="recentMeals">4 Most Recently Made Recipes: </p>
          </div>
          <div className="dynamic-display-home">
            <div className="mealsRecipe-Container">
              <div>
                <div className="mealDisplay-Flex">
                  {this.state.recipes
                    .reverse()
                    .slice(0, 4)

                    .map(recipe => (
                      <RecipeDisplay
                        key={recipe.id}
                        recipe={recipe}
                        servings={recipe.servings}
                        calories={recipe.calories}
                        name={recipe.name}
                      />
                    ))}
                </div>
              </div>
            </div>
          </div>

          <Switch>
            <Route path="/homepage/weather" render={() => <Weather />} />
            <Route exact path="/homepage/recipes" render={() => <Recipes />} />
            <Route exact path="/homepage/meals" render={() => <Meals />} />
            <Route
              path="/homepage/recipes/createnewrecipe"
              render={() => <CreateNewRecipe />}
            />
            <Route exact path="/homepage/alarms" render={() => <MyAlarms />} />
            <Route
              path="/homepage/alarms/add-alarms"
              render={() => <AddAlarms />}
            />
            {/* <Route
              path="/homepage/alarms/alarm"
              render={() => <Alarm />} */}
            />
            <Route path="/homepage/billing" render={() => <Billing />} />
            {/* <Route path="/homepage/settings" render={() => <Settings />} /> */}
          </Switch>
        </div>

        <Modal
          isOpen={this.state.modal}
          toggle={this.toggle}
          className={this.props.className}
        >
          <ModalHeader toggle={this.toggle}>
            Do you wish to log out?
          </ModalHeader>
          <Button onClick={this.logout} color="danger" className="danger">
            Log out
          </Button>
          <Button onClick={this.toggle} color="primary">
            Cancel
          </Button>
        </Modal>
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
