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
  openHamburger = () => {
    this.setState({
      open: !this.state.open
    });
  };

  logout = event => {
    event.preventDefault();
    localStorage.removeItem("token");
    localStorage.removeItem("user_id");
    this.props.history.push("/");
  };

  render() {
    return (
      <div className="Navbar-Container-Main">
        <div className="logo-main-container">
          <p className="logo-main">EatWell</p>
        </div>
        <div className="searchbar-nav-container">
          <form>
            <input type="text" className="search-box" />
          </form>
          <button className="search-button">
            <img className="search-button-img" src={Search} />
          </button>
        </div>
        <div className="hamburger-container">
          <button
            onClick={this.openHamburger}
            className={
              this.state.open
                ? "hamburger hamburger--spin is-active"
                : "hamburger hamburger--spin"
            }
          >
            <span className="hamburger-box">
              <span className="hamburger-inner" />
            </span>
          </button>
          <div className={this.state.open ? "popper" : "none"} />
          <ul className={this.state.open ? "menu-list-open" : "menu-list"}>
            <Link
              to="/homepage/meals"
              className={this.state.open ? "menu-list-item" : "none"}
            >
              <img className="menu-list-item item" src={AddMeal} />
            </Link>
            <Link
              to="/homepage/recipes"
              className={this.state.open ? "menu-list-item" : "none"}
            >
              <img className="menu-list-item item" src={Recipes} />
            </Link>
            <Link
              to="/homepage/alarms"
              className={this.state.open ? "menu-list-item" : "none"}
            >
              <img className="menu-list-item item" src={Alarms} />
            </Link>
            <Link
              to="/homepage/settings"
              className={this.state.open ? "menu-list-item" : "none"}
            >
              <img className="menu-list-item item" src={Options} />
            </Link>
            <button
              onClick={this.logout}
              className={this.state.open ? "menu-list-item-logout" : "none"}
            >
              <img className="menu-list-item item" src={Logout} />
            </button>
          </ul>
        </div>
      </div>
    );
  }
}

export default connect()(withRouter(NavbarLanding));
