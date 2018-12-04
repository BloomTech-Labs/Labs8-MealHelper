import React, { Component } from "react";
import { connect } from "react-redux";
import { addUser } from "../../store/actions/userActions";
import { withRouter, Link, Route } from "react-router-dom";
import Jars from "./Jars.jpg";
import Computer from "./Computer.jpg";
import Plate from "./Plate.png";
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
        <Navbar />
        <div className="container">
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
          <div className="info-container-one">
            <div className="image-info-container">
              <img className="image-info" src={Computer} />
            </div>
            <div className="card-body">
              <div className="header-card">
                <div>
                  <p className="info-text">Record Your Meals</p>
                </div>
                <div className="image-holder">
                  <div>
                    <img className="image-info-image" src={Plate} />
                  </div>
                </div>
              </div>
              <div className="card-body-text-container">
                <p className="card-body-text">
                  EatWell makes it easy to make a meal, and write down your
                  experience, all in one.
                </p>
              </div>
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
)(withRouter(Landingpage));
