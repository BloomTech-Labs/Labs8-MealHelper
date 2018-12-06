// == Dependencies == //
import React, { Component } from "react";
import { connect } from "react-redux";
import { Link, withRouter } from "react-router-dom";
import Select from "react-select";
// == Actions == //
import {
  fetchAlarms,
  deleteAlarm,
  updateAlarm
} from "../../store/actions/alarmActions";
// == Styles == //

const alarms = [
  {
    id: 1,
    label: "breakfast",
    alarm: "0600",
    user_id: 1
  },
  {
    id: 2,
    label: "lunch",
    alarm: "1200",
    user_id: 1
  },
  {
    id: 3,
    label: "snack",
    alarm: "1300",
    user_id: 1
  },
  {
    id: 4,
    label: "dinner",
    alarm: "1600",
    user_id: 1
  }
];

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

class MyAlarms extends Component {
  constructor(props) {
    super(props);

    this.state = {
      show: false,
      alarmToUpdate: {
        id: null,
        label: "",
        alarm: ""
      },
      label: ""
    };
  }

  componentDidMount() {
    let userID = this.props.user.userID;
    console.log("this.props.user.userID", this.props.user.userID);
    this.props.fetchAlarms(userID);
  }

  componentDidUpdate(prevProps) {
    let userID = this.props.user.userID;
    if (
      JSON.stringify(this.props.alarms) !== JSON.stringify(prevProps.alarms)
    ) {
      this.props.fetchAlarms(userID);
    }
  }

  handleChange = event => {
    event.preventDefault();
    this.setState({
      [event.target.name]: event.target.value
    });
  };

  sendToEdit(labelChange) {
    const { id, alarm } = this.state.alarmToUpdate;
    const label = labelChange;
    const alarmBody = { id, label, alarm };
    let userID = this.props.user.userID;
    this.props.updateAlarm(alarmBody, userID);
  }

  showModal = alarmID => {
    const alarmToUpdate = this.props.alarms.find(alarm => alarm.id === alarmID);
    const show = this.state.show;
    this.setState({
      ...this.state,
      show: !show,
      alarmToUpdate: alarmToUpdate
    });
  };

  militaryToStandard = time => {
    let twelve = 0;
    let format = 0;
    let twelveWithZero = 0;
    let lastNum = 0;
    if (time > 1259) {
      twelve = time - 1200;
      if (twelve > 3) {
        twelveWithZero = 0 + twelve.toString();
        format = twelveWithZero.toString().split("");
        lastNum = format[format.length - 1];
        format[2] = ":";
        format.push(lastNum);
        return format.join("");
      }
    }
    format = time.split("");
    lastNum = format[format.length - 1];
    format[2] = ":";
    format.push(lastNum);
    return format.join("");
  };

  render() {
    return (
      <div className="alarms-container">
        <div className="dynamic-display">
          <h1>Alarms</h1>
          <Link to="/homepage/alarms/add-alarms">Add New Alarms</Link>
          {console.log("THE ALARMS", theAlarms)}
          {this.props.alarms.map(alarm => (
            <div
              key={alarm.id}
              id={alarm.id}
              label={alarm.label}
              alarm={alarm.alarm}
            >
              {" "}
              <br />
              <h2>{this.militaryToStandard(alarm.alarm)}</h2>
              <h2>{alarm.label}</h2>
              <button onClick={() => this.showModal(alarm.id)}> Edit </button>
              <button
                onClick={() =>
                  this.props.deleteAlarm(alarm.id, this.props.user.userID)
                }
              >
                Delete
              </button>
            </div>
          ))}

          <editAlarmModal show={this.state.show}>
            <div className="edit-modal">
              <h2>Edit Alarm</h2>
              <input
                type="label"
                name="label"
                value={this.state.label}
                onChange={this.handleChange}
              />
              <Select
                options={options}
                className="time"
                name="alarmTime"
                onChange={opt =>
                  this.setState(prevState => ({
                    alarmToUpdate: {
                      ...prevState.alarmToUpdate,
                      alarm: opt.value
                    }
                  }))
                }
              />
              <button onClick={() => this.sendToEdit(this.state.label)}>
                Submit
              </button>
              <button onClick={() => this.showModal}>Nevermind</button>
            </div>
          </editAlarmModal>
        </div>
      </div>
    );
  }
}

const mapStateToProps = state => ({
  alarms: state.alarmsReducer.alarms,
  alarm: state.alarmsReducer.alarm,
  user: state.userReducer.user
});

export default connect(
  mapStateToProps,
  { fetchAlarms, deleteAlarm, updateAlarm }
)(withRouter(MyAlarms));
