import React, { Component } from "react";
import { connect } from "react-redux";
import "./homepage.css";
import { addUser } from "../../store/actions/userActions";
import { withRouter } from "react-router-dom";
import UserHistory from "../display/UserHistory";
import Welcome from "../Welcome/welcome";

import { Router, Route } from "react-router";

const routes = (
  <Route>
    <Route path="/zip" component={Welcome} />
  </Route>
);

Router.run(routes, Router.HashLocation, Root => {
  React.render(<Root />, document.getElementById("all"));
});

class HomePage extends Component {
  render() {
    return (
      <div className="home-container-home">
        <div className="display">
          <UserHistory />
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
