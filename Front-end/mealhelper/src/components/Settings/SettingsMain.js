import React, { Component } from "react";
import axios from "axios";
import { connect } from "react-redux";
import "../homepage/homepage";
//change the route for this
import { addUser } from "../../store/actions/userActions";
import { withRouter, Link } from "react-router-dom";
import "./settings.css";

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
      <div className="settings-container">
        <div className="Settings-Options-Container">
          <div className="settings-text">
            <h1>Settings</h1>
          </div>
          <div>
            <Link to="/homepage/settings/email">
              <button className="settings-option">Change Email</button>
            </Link>
          </div>
          <div>
            <Link to="/homepage/settings/password">
              <button className="settings-option">Change Password</button>
            </Link>
          </div>
          <div>
            <Link to="/homepage/settings/zip">
              <button className="settings-option">Change Zip</button>
            </Link>
          </div>
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
)(withRouter(SettingsMain));
