import React, { Component } from "react";
import { connect } from "react-redux";
import { withRouter, Link, Route } from "react-router-dom";
import Hamburger from "./Hamburger.png";
import Search from "./Search.svg";

import "./Navbar.css";

class NavbarLanding extends Component {
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
          <img className="hamburger" src={Hamburger} />
        </div>
      </div>
    );
  }
}

export default connect()(withRouter(NavbarLanding));
