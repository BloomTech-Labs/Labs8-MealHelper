import React, { Component } from "react";
import { connect } from "react-redux";
import { loginUser } from "../../store/actions/userActions";
import { withRouter, Link, Route } from "react-router-dom";
import { Alert } from "reactstrap";
import Sign from "../Sign";
import Callback from "../../Callback";
import "../homepage/homepage";

class Login extends Component {
  constructor(props) {
    super(props);

    this.state = {
      email: "",
      password: "",
      visable: false,
      visableError: false
    };
    this.confirmLogin = this.confirmLogin.bind(this);
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
    if (!localStorage.getItem("token")) {
      this.setState({ visableError: true });
      setTimeout(this.toggleVisability, 3000);
    } else {
      this.props.history.push("/homepage");
    }
  };
  async confirmLogin() {
    const confirmed = await this.createUser();
    setTimeout(this.loggin, 4000);
  }
  createUser = event => {
    if (!this.state.email || !this.state.password) {
      this.setState({ visable: true });
      setTimeout(this.toggleVisability, 3000);
    } else {
      const { email, password } = this.state;
      const user = { email, password };
      this.props.loginUser(user);
    }
  };

  render() {
    return (
      <div className="main-container">
        <div className="alert-box3">
          <Alert isOpen={this.state.visableError} color="danger">
            Invalid Email and/or Password. Please Try Again.
          </Alert>
        </div>
        <div className="formcenter">
          <div className="user-form-container-login">
            <h1 className="signup-title">Login</h1>

            <form className="login-form">
              <div className="form-group">
                <input
                  id="dynamic-label-input"
                  className="email-input"
                  type="email"
                  name="email"
                  value={this.state.email}
                  onChange={this.handleChange}
                  placeholder="Email"
                  required
                />
                <label htmlFor="dynamic-label-input">Email</label>
              </div>
              <div className="form-group2">
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
              <div className="signup signup-two" onClick={this.confirmLogin}>
                <span>Log In</span>
              </div>
              <div className="auth">
                <p className="signuptext">Don't have an account?</p>
              </div>
              <Link to="/signup">
                <div className="signup signup-two">
                  <button className="buttons">
                    <span>Signup</span>
                  </button>
                </div>
              </Link>

              <p className="signuptext2">- Or -</p>
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
  user: state.userReducer.user
});

export default connect(
  mapStateToProps,
  { loginUser }
)(withRouter(Login));
