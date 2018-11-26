import React, { Component } from "react";
import { connect } from "react-redux";
import { withRouter } from "react-router-dom"
import moment from "moment";
// import actions

class AddAlarm extends Component {
  constructor(props) {
    super(props);

    this.state = {
      
    }
  }

  handleChange = event => {
    event.preventDefault();
    this.setState({
      [event.target.name]: event.target.value
    });
  };

  addAlarm = event => {
    event.preventDefault();
    //make sure all required fields are filled in
    //get fields from state
    //assign values to alarm body
    //pass alarm body to addAlarm actions
    //this.props.history.push to alarms list
  }
}

const mapStateToProps = state => ({
  //map the state
})

export default connect(
  mapStateToProps,
  //action
)(withRouter(AddAlarm))
)