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
      visable: false,
      visableError: false
    };
    this.confirmSignup = this.confirmSignup.bind(this);
  }
  componentDidMount = () => {
    if (localStorage.getItem("token")) {
      this.props.history.push("/homepage");
    }
  };
  handleChange = event => {
    event.preventDefault();
    this.setState({
      [event.target.name]: event.target.value
    });
  };

  toggleVisability = () => {
    this.setState({ visableError: false, visable: false });
  };
  loggin = event => {
    console.log(localStorage.getItem("token"));
    if (!localStorage.getItem("token")) {
      this.setState({ visableError: true });
      setTimeout(this.toggleVisability, 3000);
    } else {
      this.props.history.push("/homepage");
    }
  };
  async confirmSignup() {
    const confirmed = await this.createUser();
    setTimeout(this.loggin, 7000);
  }
  createUser = event => {
    if (!this.state.email || !this.state.password) {
      this.setState({ visable: true });
      setTimeout(this.toggleVisability, 3000);
    } else {
      const { email, password, zip, healthCondition } = this.state;
      const user = { email, password, zip, healthCondition };
      this.props.addUser(user);
    }
  };

  render() {
    return (
      <div className="main-container">
        <div className="alert-box3">
          <Alert isOpen={this.state.visableError} color="danger">
            Error Creating User, please try again
          </Alert>
        </div>
        <div className="alert-box3">
          <Alert isOpen={this.state.visable} color="danger">
            Please enter an email
          </Alert>
        </div>
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
              <div className="signup signup-two" onClick={this.confirmSignup}>
                <span>Sign Up</span>
              </div>
              <div className="auth">
                <p className="signuptext">Already have an account?</p>
              </div>
              <Link to="/login">
                <div className="signup signup-two">
                  <button className="buttons">
                    <span>Login</span>
                  </button>
                </div>
              </Link>
              <p className="signuptext">- Or -</p>
            </form>
            <div>
              <Sign />
              <Route exact path="/callback" component={Callback} />
            </div>
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
