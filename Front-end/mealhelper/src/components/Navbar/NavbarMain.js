import React, { Component } from "react";
import { connect } from "react-redux";
import { withRouter, Link } from "react-router-dom";
import Search from "./Search.svg";
import AddMeal from "./Add-Meal.png";
import Recipes from "./Recipes.png";
import Alarms from "./Alarms.png";
import Options from "./Options.png";
import Logout from "./Logout.png";
import "../../hamburgers.css";
import "./Navbar.css";

class NavbarLanding extends Component {
  constructor() {
    super();
    this.state = {
      open: false
    };
  }
  // openHamburger = () => {
  //   this.setState({
  //     open: !this.state.open
  //   });
  // };

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
      <div className="Navbar-Container-Main">
        <div className="logo-main-container">
          <Link className="link-logo" to="/homepage">
            <p className="logo-main">EatWell</p>
          </Link>
        </div>
        {/* <div className="searchbar-nav-container">
          <form>
            <input type="text" className="search-box" />
          </form>
          <button className="search-button">
            <img className="search-button-img" src={Search} />
          </button>
        </div> */}
        <div
          className="navbar-section-links"
          style={{ textDecoration: "none" }}
        >
          <Link
            to="/homepage"
            className="navbar-section-links-style"
            style={{ textDecoration: "none" }}
          >
            <h3>Home</h3>
          </Link>
          <Link
            to="/homepage/meals/new"
            className="navbar-section-links-style"
            style={{ textDecoration: "none" }}
          >
            <h3>Make A Meal</h3>
          </Link>
          <Link
            to="/homepage/recipes"
            className="navbar-section-links-style"
            style={{ textDecoration: "none" }}
          >
            <h3>Add A Recipe</h3>
          </Link>
          <Link
            to="/homepage/alarms"
            className="navbar-section-links-style"
            style={{ textDecoration: "none" }}
          >
            <h3>Add An Alarm</h3>
          </Link>
          <Link
            to="/homepage/settings"
            className="navbar-section-links-style"
            style={{ textDecoration: "none" }}
          >
            <h3>Settings</h3>
          </Link>
          <a onClick={this.logout} style={{ textDecoration: "none" }}>
            <h3 className="navbar-section-links-style-logout">Logout</h3>
          </a>
        </div>
      </div>
    );
  }
}

export default connect()(withRouter(NavbarLanding));
