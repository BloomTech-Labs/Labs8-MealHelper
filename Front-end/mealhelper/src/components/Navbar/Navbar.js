import React, { Component } from "react";
import { connect } from "react-redux";
import { withRouter, Link, Route } from "react-router-dom";

import "./Navbar.css";

class NavbarLanding extends Component {
  render() {
    return (
      <div className="Navbar-Container">
        <p className="logo">EatWell</p>
      </div>
    );
  }
}

export default connect()(withRouter(NavbarLanding));
