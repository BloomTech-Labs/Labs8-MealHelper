import React, { Component } from "react";
import { connect } from "react-redux";
import "./homepage.css";
import { addUser } from "../../store/actions/userActions";
import { withRouter, Link } from "react-router-dom";
import UserHistory from "../display/UserHistory";
// import Welcome from "../welcome/welcome";

import { Router, Route } from "react-router";

class HomePage extends Component {
  logout = event => {
    // this.setState({
    //   open: !this.state.open
    // });
    event.preventDefault();
    localStorage.removeItem("token");
    localStorage.removeItem("user_id");
    this.props.history.push("/");
  };
  render() {
    return (
      // <div className="home-container-home">
      <div className="homepage-main-fence">
        <div className="user-profile-card">
          <Link to="/homepage/settings" style={{ textDecoration: "none" }}>
            <div className="user-profile-card-howto">How To:</div>
          </Link>
          <Link to="/homepage/settings" style={{ textDecoration: "none" }}>
            <div className="user-profile-card-settings">Settings</div>
          </Link>
          <a onClick={this.logout} style={{ textDecoration: "none" }}>
            <div className="user-profile-card-logout">Logout</div>
          </a>
          <h1 className="user-profile-card-cta">
            Let's <h1 className="user-profile-card-cta-logo">EatWell</h1>
            [username]!
          </h1>
          <div className="user-profile-card-infobox">
            <p className="user-profile-card-infobox-date">Today is:</p>
            <p className="user-profile-card-infobox-last-meal">
              Your last meal was:
            </p>
            <p className="user-profile-card-infobox-next-meal">
              Your next meal will be in:
            </p>
          </div>
          <div className="">Total Stats</div>
          <div
            className="user-profile-card-stats"
            style={{ textDecoration: "none" }}
          >
            <Link
              to="/homepage/meals"
              className="stat-divider"
              style={{ textDecoration: "none" }}
            >
              <h3 className="stat-text">Meals</h3>
            </Link>
            <Link
              to="/homepage/recipes"
              className="stat-divider"
              style={{ textDecoration: "none" }}
            >
              <h3 className="stat-text">Recipes</h3>
            </Link>
            <Link
              to="/homepage/alarms"
              className="stat-divider"
              style={{ textDecoration: "none" }}
            >
              <h3 className="stat-text">Alarms</h3>
            </Link>
          </div>
          <div
            className="user-profile-card-stats-live"
            style={{ textDecoration: "none" }}
          >
            <Link
              to="/homepage/meals"
              className="stat-divider-live"
              style={{ textDecoration: "none" }}
            >
              <h3 className="stat-text-live">Meals</h3>
            </Link>
            <Link
              to="/homepage/recipes"
              className="stat-divider-live"
              style={{ textDecoration: "none" }}
            >
              <h3 className="stat-text-live">Recipes</h3>
            </Link>
            <Link
              to="/homepage/alarms"
              className="stat-divider-live"
              style={{ textDecoration: "none" }}
            >
              <h3 className="stat-text-live">Alarms</h3>
            </Link>
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
        <div class="inapp-choice-wrapper">
          <div class="box recipes">
            Step 1: Recipes
            <br />
            <p className="recipes-text">
              It all starts with the recipe. Click recipe and start adding your
              ingredients!
            </p>
          </div>
          <div class="box meals">
            Step 3: Meals <br />
            <p className="meals-text">
              Then name your meal and add the recipe.
            </p>
          </div>
          <div class="box ingredients">
            Step 2: Ingredients <br />
            <p className="ingredients-text">
              From your recipe modal, enter your ingredients and save them.
            </p>
          </div>
          <div class="box alarms">
            Step 4: Alarms
            <br />
            <p className="alarms-text">
              And last, set your alarms to remind you to eat.
            </p>
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
