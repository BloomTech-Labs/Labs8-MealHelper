import React, { Component } from "react";
import Sign from "../Sign";
import Callback from "../../Callback";
import { connect } from "react-redux";
//change the route for this
import { addUser } from "../../store/actions/userActions";
import { withRouter, Link, Route } from "react-router-dom";
import { Alert } from "reactstrap";
import "./signup.css";

class SignUp extends Component {
  constructor(props) {
    super(props);

    this.state = {
      email: "",
      password: "",
      zip: null,
      healthCondition: "",
      visable: false
    };
  }

  handleChange = event => {
    event.preventDefault();
    this.setState({
      [event.target.name]: event.target.value
    });
  };

  signupp = event => {
    if (localStorage.getItem("token") !== undefined) {
      this.props.history.push("/homepage");
    } else {
      setTimeout(() => {
        this.signupp();
      }, 6000);
    }
  };

  createUser = event => {
    event.preventDefault();
    if (!this.state.email || !this.state.password) {
      this.setState({ visable: true });
    } else {
      const { email, password, zip, healthCondition } = this.state;
      const user = { email, password, zip, healthCondition };
      this.props.addUser(user);
      setTimeout(() => {
        this.signupp();
      }, 6000);
    }
  };

  render() {
    return (
      <div className="main-container">
        <div className="formcenter">
          <div className="user-form-container">
            <h1 className="signup-title">Sign Up</h1>
            <form className="signup-form">
              <div className="form-group">
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
              </div>
              <div className="form-group">
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
              </div>
              <div className="form-group">
                <input
                  id="dynamic-label-input"
                  className="zip-input"
                  type="number"
                  name="zip"
                  onChange={this.handleChange}
                  value={this.state.zip}
                  placeholder="Zip"
                />
                <label htmlFor="dynamic-label-input">Zip Code</label>
              </div>
              <div className="form-group">
                <input
                  id="dynamic-label-input"
                  className="condition-input"
                  type="text"
                  name="healthCondition"
                  onChange={this.handleChange}
                  value={this.state.healthCondition}
                  placeholder="Health Condition"
                />
                <label htmlFor="dynamic-label-input">Health Condition</label>
              </div>
              <div className="signup signup-two" onClick={this.createUser}>
                <span>Sign Up</span>
              </div>
              <div className="auth">
                <p className="signuptext">Already have an account?</p>
              </div>
              <div className="existinguser">
                <Link to="/login">
                  <button className="login-button">
                    <span>Login</span>
                  </button>
                </Link>
                <p className="signuptext">Or</p>
              </div>
              <div className="alert-box">
                <Alert isOpen={this.state.visable} color="danger">
                  Please enter an email
                </Alert>
              </div>
            </form>

            <Sign />
            <Route exact path="/callback" component={Callback} />
          </div>
        </div>
      </div>
    );
  }
}

const mapStateToProps = state => ({
  user: state.user
});

export default connect(
  mapStateToProps,
  { addUser }
)(withRouter(SignUp));
