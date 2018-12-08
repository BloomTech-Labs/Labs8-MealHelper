import React, { Component } from "react";
import Sign from "../Sign";
import { connect } from "react-redux";
import { addUser } from "../../store/actions/userActions";
import { withRouter, Link } from "react-router-dom";
import { Alert } from "reactstrap";
import Navbar from "../Navbar/Navbar";
import Loading from "./Double Ring-2s-200px.svg";
import Applelogo from "../../img/appstorebadge.png";
import "./signup.css";

class SignUp extends Component {
  constructor(props) {
    super(props);

    this.state = {
      email: "",
      password: "",
      zip: null,
      healthCondition: "",
      isLoading: false,
      visable: false,
      visableError: false
    };
    this.confirmSignup = this.confirmSignup.bind(this);
  }
  componentDidMount = () => {
    if (localStorage.getItem("token")) {
      this.props.history.push("/zip");
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
      this.setState({ isLoading: false });
      this.setState({ visableError: true });
      setTimeout(this.toggleVisability, 3000);
    } else {
      this.props.history.push("/zip");
    }
  };
  async confirmSignup() {
    this.setState({ isLoading: true });
    const confirmed = await this.createUser();
    setTimeout(this.loggin, 7000);
  }
  createUser = event => {
    if (!this.state.email || !this.state.password) {
      this.setState({ visable: true });
      setTimeout(this.toggleVisability, 3000);
    } else {
      const { email, password, zip } = this.state;
      const user = { email, password, zip };
      this.props.addUser(user);
    }
  };

  render() {
    return (
      <div className="main-container">
        {this.state.isLoading ? (
          <div className="isLoading">
            <img className="loading" src={Loading} alt="Loading icon" />
          </div>
        ) : (
          <div>
            <Navbar />
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
                <Link to="/" style={{ textDecoration: "none" }}>
                  <h1 className="signup-title">EatWell</h1>
                </Link>
                <form className="signup-form">
                  <div className="form-group">
                    <label>Email</label>
                    <input
                      className="email-input"
                      type="email"
                      name="email"
                      value={this.state.email}
                      onChange={this.handleChange}
                    />
                  </div>
                  <div className="form-group">
                    <label>Password</label>
                    <input
                      className="password-input"
                      type="password"
                      name="password"
                      onChange={this.handleChange}
                      value={this.state.password}
                    />
                  </div>
                  <div className="signup" onClick={this.confirmSignup}>
                    <span>Sign Up</span>
                  </div>
                  <p className="cta-existing-account">
                    Already Have An Account?
                  </p>
                  <Link to="/login" style={{ textDecoration: "none" }}>
                    <div className="login">
                      <span>Login with Email</span>
                    </div>
                  </Link>
                </form>
                <div className="authbuttonlogin">
                  <Sign />
                </div>
                <a href="https://www.apple.com/ios/app-store/">
                  <img
                    className="applebadge"
                    src={Applelogo}
                    alt="Apple App Store"
                  />
                </a>
              </div>
            </div>
          </div>
        )}
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
