import React, { Component } from "react";
import { connect } from "react-redux";
import "./homepage.css";
import { addUser } from "../../store/actions/userActions";
import { withRouter } from "react-router-dom";
import UserHistory from "../display/UserHistory";
// import Welcome from "../welcome/welcome";

import { Router, Route } from "react-router";

class HomePage extends Component {
  render() {
    return (
      // <div className="home-container-home">
      <div className="user-profile-card">
        <h1 className="user-profile-card-cta">
          Let's <h1 className="user-profile-card-cta-logo">EatWell</h1>
          [username]!
        </h1>
        <div
          className="user-profile-card-stats"
          style={{ textDecoration: "none" }}
        >
          <a href="#product" className="stat">
            <h3>Meals</h3>
          </a>
          <a href="#pricing" className="stat">
            <h3>Recipes</h3>
          </a>
          <a href="#team" className="stat">
            <h3>Alarms</h3>
          </a>
        </div>
        <div className="user-profile-card-body">
          <p className="user-profile-card-body-text">
            Eat. Track. Analyze. <br />
            <p className="user-profile-card-body-text-logo">EatWell</p>
          </p>
        </div>

        {/* <UserHistory /> */}
        {/* </div> */}
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
)(withRouter(HomePage));
