import React, { Component } from "react";
import { connect } from "react-redux";
import { withRouter } from "react-router-dom"
import moment from "moment";
// import actions

class AddAlarms extends Component {
  constructor(props) {
    super(props);

    this.state = {
      beginTime: 0,
      endTime: 0,
      repeats: 0
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

  //convert beginTime and endTime to military time
  // calculate how many alarms between beginTime and endTime using repeats
  // take amount of alarms and insert bulk data to database

  render() {
    return (
      <div className="alarms-container">
      <h1>Add Alarms</h1>
        <form className="forms">
          <input
            className="time"
            name="beginTime"
            value={this.state.beginTime}
            onChange={this.handleChange}
            placeholder="Beginning Time"
          />
          <input
            className="time"
            name="endTime"
            value={this.state.endTime}
            onChange={this.handleChange}
            placeholder="Ending Time"
          />
          <input
            className="repeat"
            name="repeat"
            value={this.state.repeat}
            onChange={this.handleChange}
            placeholder="Hours between each alarm"
          />
        </form>
        <button onClick={this.addAlarm} className="add-alarms btn">
          Add Alarms
        </button>
      </div>
    )
  }
}

const mapStateToProps = state => ({
  //map the state
});

export default connect(
  mapStateToProps,
  //action
)(withRouter(AddAlarms));
