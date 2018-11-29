import React, { Component } from "react";
import { connect } from "react-redux";
import { loginUser } from "../../store/actions/userActions";
import { withRouter, Link } from "react-router-dom";
import { Alert } from "reactstrap";

class Login extends Component {
  constructor(props) {
    super(props);

    this.state = {
      email: "",
      password: "",
      visable: false
    };
  }

  handleChange = event => {
    event.preventDefault();
    this.setState({
      [event.target.name]: event.target.value
    });
  };

  loggin = event => {
    if (localStorage.getItem("token") !== undefined) {
      this.props.history.push("/homepage");
    } else {
      setTimeout(() => {
        this.loggin();
      }, 2000);
    }
  };

  createUser = event => {
    event.preventDefault();
    if (!this.state.email || !this.state.password) {
      this.setState({ visable: true });
    } else {
      const { email, password } = this.state;
      const user = { email, password };
      this.props.loginUser(user);
      console.log(this.props);
      setTimeout(() => {
        this.loggin();
      }, 6000);
    }
  };

  render() {
    return (
      <div className="main-container">
        <div className="formcenter">
          <div className="user-form-container">
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
              <div className="signup signup-two" onClick={this.createUser}>
                <span>Log In</span>
              </div>
              <div className="entry-button-group">
                <Link to="/signup">
                  <button className="signup signup-two">
                    <span>Signup</span>
                  </button>
                </Link>
              </div>
              <div className="alert-box">
                <Alert isOpen={this.state.visable} color="danger">
                  Please enter an email and address
                </Alert>
              </div>
            </form>
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
