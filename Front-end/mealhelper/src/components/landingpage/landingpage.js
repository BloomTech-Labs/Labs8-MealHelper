import React, { Component } from "react";
import { connect } from "react-redux";
import { addUser } from "../../store/actions/userActions";
import { withRouter, Link, Route } from "react-router-dom";
import Jars from "./Jars.jpg";
import Navbar from "../Navbar/Navbar";
import "./landingpage.css";

class Landingpage extends Component {
  componentDidMount = () => {
    if (localStorage.getItem("token")) {
      this.props.history.push("/homepage");
    }
  };

  goToSignup = () => {
    this.props.history.push("/signup");
  };
  goToLogin = () => {
    this.props.history.push("/login");
  };

  render() {
    return (
      <div className="main-container">
        <div>
          <Navbar />
        </div>
        <div className="image-jars-container">
          <img className="image-jars" src={Jars} alt="No image" />
        </div>
        <div className="login-signup-container">
          <div className="button-container">
            <button className="button">
              <p className="button-text" onClick={this.goToSignup}>
                Sign Up
              </p>
            </button>
          </div>
          <div className="button-container">
            <button className="button">
              <p className="button-text" onClick={this.goToLogin}>
                Log In
              </p>
            </button>
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
)(withRouter(Landingpage));
