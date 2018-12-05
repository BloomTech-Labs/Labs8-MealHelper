import React, { Component } from "react";
import { connect } from "react-redux";
import { withRouter, Link, Route } from "react-router-dom";
import Hamburger from "./Hamburger.png";
import Search from "./Search.svg";
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
            <span class="hamburger-box">
              <span class="hamburger-inner" />
            </span>
          </button>
          <div className={this.state.open ? "popper" : "none"} />
          <ul className={this.state.open ? "menu-list-open" : "menu-list"}>
            <li className="menu-list-item">1</li>
            <li className="menu-list-item">2</li>
            <li className="menu-list-item">3</li>
            <li className="menu-list-item">4</li>
            <li className="menu-list-item">5</li>
          </ul>
        </div>
        {/* <div className="dd-wrapper">
          <div className="dd-header">
            <div className="dd-header-title" />
          </div>
          <ul className="dd-list">
            <li className="dd-list-item" />
            <li className="dd-list-item" />
            <li className="dd-list-item" />
          </ul>
        </div> */}
      </div>
    );
  }
}

export default connect()(withRouter(NavbarLanding));
