import React, { Component } from "react";
import { connect } from "react-redux";
import { addUser } from "../../store/actions/userActions";
import { withRouter } from "react-router-dom";

class Welcome extends Component {
  render() {
    return (
      <div className="welcome-message">
        <h1>First time using EatWell?</h1>
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
)(withRouter(Welcome));
