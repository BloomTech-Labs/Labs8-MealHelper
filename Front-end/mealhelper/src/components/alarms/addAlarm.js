import React, { Component } from "react";
import { connect } from "react-redux";
import { withRouter } from "react-router-dom";
//import moment from "moment";
import Select from "react-select";
import { addAlarms } from "../../store/actions/alarmActions";

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
      beginTime: null,
      endTime: null,
      repeats: null
    };
  }

  handleChange = event => {
    event.preventDefault();
    this.setState({
      [event.target.name]: event.target.value
    });
  };

  addAlarm = event => {
    event.preventDefault();
    console.log("THIS.PROPS", this.props);
    console.log("THIS.PROPS.USER", this.props.user)
   const user_id = this.props.user.userID;
    if (!this.state.beginTime || !this.state.endTime || !this.state.repeats) {
      //alert that all fields are required
    } else {
      let start = Number(this.state.beginTime); 
      let end = Number(this.state.endTime); 
      let repeats = +this.state.repeats * 100;
      console.log("repeats", repeats);
      let alarmTimes = [];
      for (let i = start; i <= end; i += repeats) {
        if (i.toString().length === 3) {
          let alarm = 0 + i.toString();
          alarmTimes.push({ user_id: user_id, label: "", alarm: alarm });
        } else {
          let alarm = i.toString();
          alarmTimes.push({ user_id: user_id, label: "", alarm: alarm });
        }
      }
      console.log("alarmTimes", alarmTimes)
        alarmTimes.map(alarm => console.log("alarm map", alarm));
        alarmTimes.map(alarm => this.props.addAlarms(alarm));
       this.props.history.push('/homepage/alarms')
    }
  };

  render() {
    return (
      <div className="alarms-container">
        <div className="home-container">
          <h1>Add Alarms</h1>
          <form className="forms">
            <Select
              options={options}
              className="time"
              name="beginTime"
              placeholder="Start Time"
              onChange={opt => this.setState({ beginTime: opt.value })}
            />

            <Select
              options={options}
              className="time"
              name="endTime"
              placeholder="End Time"
              onChange={opt => this.setState({ endTime: opt.value })}
            />
            <input
              className="repeats"
              name="repeats"
              value={this.state.repeats}
              onChange={this.handleChange}
              placeholder="Hours between each alarm"
            />
          </form>
          <button onClick={this.addAlarm} className="add-alarms btn">
            Add Alarms
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
