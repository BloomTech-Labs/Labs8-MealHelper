// == Dependencies == //
import React, { Component } from "react";
import axios from "axios";
import { connect } from "react-redux";
import { withRouter, Link, Route, Switch } from "react-router-dom";
// == Components == //
import MealDisplay from "../display/MealDisplay";
import RecipeDisplay from "../display/RecipeDisplay";
import Weather from "../weather/weather";
import Recipes from "../recipes/recipes";
import Meals from "../Meals/Meals";
import CreateNewRecipe from "../creatnewrecipe/createnewrecipe";
import AddAlarms from "../alarms/addAlarm";
import MyAlarms from "../alarms/myAlarms";
import Billing from "../billing/billing";
// == Actions == //
import { addUser } from "../../store/actions/userActions";
// == Styles == //
import {
  Button,
  Modal,
  ModalHeader,
} from "reactstrap";

class SideBar extends Component {
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
    const id = localStorage.getItem("user_id");
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
      //   <div className="home-container-home">
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
          <Route path="/homepage/billing" render={() => <Billing />} />
          {/* <Route path="/homepage/settings" render={() => <Settings />} /> */}
        </Switch>

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
)(withRouter(SideBar));
