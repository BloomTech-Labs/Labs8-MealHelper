// == Dependencies == //
import React, { Component } from "react";
import axios from "axios";
import { connect } from "react-redux";
import { withRouter, Link } from "react-router-dom";
// == Components == //
import "../homepage/homepage";
// == Actions == //
import { addUser } from "../../store/actions/userActions";
// == Styles == //
import {
  Button,
  Modal,
  ModalHeader,
} from "reactstrap";

class SettingsMain extends Component {
  constructor(props) {
    super(props);

    this.state = {
      user: [],
      email: "",
      password: "",
      zip: null,
      healthCondition: "",
      visable: false,
      modal: false
    };
  }

  componentDidMount = () => {
    if (localStorage.getItem("token")) {
      const id = localStorage.getItem("user_id");
      axios
        .get(`https://labs8-meal-helper.herokuapp.com/users/${id}`)
        .then(user => {
          this.setState({ user: user.data });
        })
        .catch(err => {
          console.log(err);
        });
    } else {
      this.props.history.push("/");
    }
  };

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
        <div className="flex-me-settings">
          <div className="dynamic-display-home-meals">
            <p className="recentMeals">Settings Page </p>
          </div>
          <div className="dynamic-display-home-settings">
            <p className="recentMeals">Email </p>
            <Link className="buttons" to="/homepage/settings/email">
              <button className="buttons-settings">Edit</button>
            </Link>
          </div>
          <div className="dynamic-display-home-settings">
            <p className="recentMeals">Password </p>
            <Link className="buttons" to="/homepage/settings/password">
              <button className="buttons-settings">Edit</button>
            </Link>
          </div>
          <div className="dynamic-display-home-settings">
            <p className="recentMeals">Zip </p>
            <Link className="buttons" to="/homepage/settings/zip">
              <button className="buttons-settings">Edit</button>
            </Link>
          </div>

          {/* <Switch>
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
         {/* </Switch> */}
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
)(withRouter(SettingsMain));
