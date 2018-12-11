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
      <div className="home-container-home">
        <div className="display-quote">
          <div className="quote-box">
            <h1 className="familiar-greeting">Welcome Back!</h1>
            <p className="quote-text">Food Quote Of The Day</p>
          </div>
          <div>
            <UserHistory />
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
)(withRouter(HomePage));
