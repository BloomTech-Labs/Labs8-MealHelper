import React, { Component } from "react";
import axios from "axios";
import { connect } from "react-redux";
import "../homepage/homepage";
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

class EditEmail extends Component {
  constructor(props) {
    super(props);

    this.state = {
      user: [],
      updated: false,
      email: "",
      password: "",
      zip: null,
      healthCondition: "",
      visable: false,
      modal: false
    };
    this.confirmChange = this.confirmChange.bind(this);
  }

  componentDidMount = () => {
    const id = this.props.user.userID;
    axios
      .get(`https://labs8-meal-helper.herokuapp.com/users/${id}`)
      .then(user => {
        this.setState({ user: user.data });
      })
      .catch(err => {
        console.log(err);
      });
  };
  goHome = () => {
    if (this.state.updated === true) {
      this.props.history.push("/homepage");
    } else {
      alert("Error updating settins. Our server may be down.");
    }
  };
  async confirmChange() {
    const confirmed = await this.changeEmail();
    setTimeout(this.goHome, 8000);
  }
  handleChange = event => {
    event.preventDefault();
    this.setState({
      [event.target.name]: event.target.value
    });
  };
  toggleVisability = () => {
    this.setState({ visable: false });
  };
  changeEmail = event => {
    if (!this.state.email || !this.state.password) {
      this.setState({ visable: true });
      setTimeout(this.toggleVisability, 3000);
    } else {
      const id = this.props.user.userID;
      const { email, password } = this.state;
      const user = { email, password };
      axios
        .put(`https://labs8-meal-helper.herokuapp.com/users/email/${id}`, user)
        .then(response => {
          console.log(response);
          this.setState({ updated: true });
        });
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

        <div className="flex-me-settings">
          <div className="dynamic-display-home-meals">
            <p className="recentMeals">Change Email </p>
          </div>

          <div className="dynamic-display-home-settings">
            <p className="recentMeals">Email </p>
            <form className="editSettings">
              <input
                id="dynamic-label-input"
                className="email-input"
                type="email"
                name="email"
                value={this.state.email}
                onChange={this.handleChange}
                placeholder="Email"
              />
              <label htmlFor="dynamic-label-input">Email</label>
              <input
                id="dynamic-label-input"
                className="password-input"
                type="password"
                name="password"
                onChange={this.handleChange}
                value={this.state.password}
                placeholder="Password"
              />
              <label htmlFor="dynamic-label-input">Password</label>
            </form>

            <div className="buttons-settings" onClick={this.confirmChange}>
              <span>Submit</span>
            </div>
          </div>
          <div className="alert-box2">
            <Alert isOpen={this.state.visable} color="danger">
              Please enter an email and/or Password.
            </Alert>
          </div>
          <div className="alert-box2">
            <Alert isOpen={this.state.updated} color="success">
              Settings have been updated! Please wait while you are
              redirected...
            </Alert>
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
  user: state.userReducer.user
});

export default connect(
  mapStateToProps,
  { addUser }
)(withRouter(EditEmail));
