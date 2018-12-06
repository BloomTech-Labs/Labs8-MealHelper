// == Dependencies == //
import React, { Component } from "react";
import { connect } from "react-redux";
import { withRouter } from "react-router-dom";
import Select from "react-select";
import { Button } from "reactstrap";
// == Actions == //
import { addAlarms } from "../../store/actions/alarmActions";
// == Styles == //
import "./addAlarm.css";

//this is embarrassingly not DRY; auto-populate ASAP
const options = [
  { value: "0100", label: "1:00 AM" },
  { value: "0200", label: "2:00 AM" },
  { value: "0300", label: "3:00 AM" },
  { value: "0400", label: "4:00 AM" },
  { value: "0500", label: "5:00 AM" },
  { value: "0600", label: "6:00 AM" },
  { value: "0700", label: "7:00 AM" },
  { value: "0800", label: "8:00 AM" },
  { value: "0900", label: "9:00 AM" },
  { value: "1000", label: "10:00 AM" },
  { value: "1100", label: "11:00 AM" },
  { value: "1200", label: "12:00 PM" },
  { value: "1300", label: "1:00 PM" },
  { value: "1400", label: "2:00 PM" },
  { value: "1500", label: "3:00 PM" },
  { value: "1600", label: "4:00 PM" },
  { value: "1700", label: "5:00 PM" },
  { value: "1800", label: "6:00 PM" },
  { value: "1900", label: "7:00 PM" },
  { value: "2000", label: "8:00 PM" },
  { value: "2100", label: "9:00 PM" },
  { value: "2200", label: "10:00 PM" },
  { value: "2300", label: "11:00 PM" },
  { value: "2400", label: "12:00 AM (midnight)" }
];

class AddAlarms extends Component {
  constructor(props) {
    super(props);

    this.state = {
      startTime: null,
      endTime: null,
      repeats: null,
      timestamp: null,
      alarmTime: null,
      label: ""
    };
  }

  handleChange = event => {
    event.preventDefault();
    this.setState({
      [event.target.name]: event.target.value
    });
  };

  handleCheck = day => {
    this.setState({
      [day]: !this.state[day]
    });
  };

  addAlarm = event => {
    event.preventDefault();
    //grabs user id from state
    const user_id = this.props.user.userID;
    if (!this.state.startTime || !this.state.endTime || !this.state.repeats) {
      //alert that all fields are required
    } else {
      let start = Number(this.state.startTime);
      let end = Number(this.state.endTime);
      let repeats = +this.state.repeats * 100;

      let timestamp = Math.round(new Date().getTime() / 1000.0);

      let alarmTimes = [];
      for (let i = start; i <= end; i += repeats) {
        if (i.toString().length === 3) {
          let alarm = 0 + i.toString();
          alarmTimes.push({
            user_id: user_id,
            label: "",
            alarm: alarm,
            timestamp: timestamp
          });
        } else {
          let alarm = i.toString();
          alarmTimes.push({
            user_id: user_id,
            label: "",
            alarm: alarm,
            timestamp: timestamp
          });
        }
      }
      alarmTimes.map(alarm => this.props.addAlarms(alarm));
      this.props.history.push("/homepage/alarms");
    }
  };

  addSingleAlarm = event => {
    event.preventDefault();
    const user_id = this.props.user.userID;
    let alarm = this.state.alarmTime;
    let label = this.state.label;
    let timestamp = Math.round(new Date().getTime() / 1000.0);

    let alarmBody = {
      user_id: user_id,
      label: label,
      alarm: alarm,
      timestamp: timestamp
    };
    this.props.addAlarms(alarmBody);
    this.props.history.push("/homepage/alarms");
  };

  render() {
    return (
      <div className="add-alarms-container">
        <div className="add-alarms-forms">
          <div className="add-alarms-heading">
            <h1>Add Alarms in a Batch</h1>
          </div>
          <form className="add-alarm-form">
            <h3>What should the time be for your first alarm?</h3>
            <Select
              options={options}
              className="time"
              name="startTime"
              placeholder="Start Time"
              onChange={opt => this.setState({ startTime: opt.value })}
            />
            <h3>What should the time be for your last alarm?</h3>
            <Select
              options={options}
              className="time"
              name="endTime"
              placeholder="End Time"
              onChange={opt => this.setState({ endTime: opt.value })}
            />
            <h3>How many hours should pass between each alarm?</h3>
            <input
              className="repeats"
              name="repeats"
              value={this.state.repeats}
              onChange={this.handleChange}
              placeholder="Hours between each alarm"
            />
          </form>
          <button onClick={this.addAlarm} className="add-alarms btn">
            Add Alarm Batch
          </button>
        </div>

        <div className="add-alarms-forms">
          <div className="add-alarms-heading">
            <h1>Add a Single Alarm</h1>
          </div>

          <form className="add-alarm-form">
            <Select
              options={options}
              className="time"
              name="alarmTime"
              placeholder="Alarm Time"
              onChange={opt => this.setState({ alarmTime: opt.value })}
            />
            <input
              className="label"
              name="label"
              value={this.state.label}
              onChange={this.handleChange}
              placeholder="Alarm label"
            />
          </form>
          <button onClick={this.addSingleAlarm} className="add-alarms btn">
            Add Alarm
          </button>
        </div>
      </div>
    );
  }
}

const mapStateToProps = state => ({
  user: state.userReducer.user
});

export default connect(
  mapStateToProps,
  { addAlarms }
)(withRouter(AddAlarms));
