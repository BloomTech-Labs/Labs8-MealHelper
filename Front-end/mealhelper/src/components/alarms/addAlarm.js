import React, { Component } from "react";
import { connect } from "react-redux";
import { Link, withRouter } from "react-router-dom";
//import moment from "moment";
import Select from "react-select";
import { addAlarms } from "../../store/actions/alarmActions";
import moment from "moment";
import { Button } from "reactstrap";
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
      monday: false,
      tuesday: false,
      wednesday: false,
      thursday: false,
      friday: false,
      saturday: false,
      sunday: false,
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
    console.log(day, this.state[day]);
    this.setState({
      [day]: !this.state[day]
    });
  };

  addAlarm = event => {
    event.preventDefault();
    // console.log("THIS.PROPS", this.props);
    // console.log("THIS.PROPS.USER", this.props.user);
    const user_id = this.props.user.userID;
    if (!this.state.startTime || !this.state.endTime || !this.state.repeats) {
      //alert that all fields are required
    } else {
      let start = Number(this.state.startTime);
      let end = Number(this.state.endTime);
      let repeats = +this.state.repeats * 100;
      let timestamp = Math.round(new Date().getTime() / 1000.0);
      console.log("TIMESTAMP", timestamp);
      let alarmTimes = [];
      for (let i = start; i <= end; i += repeats) {
        if (i.toString().length === 3) {
          let alarm = 0 + i.toString();
          alarmTimes.push({
            user_id: user_id,
            label: "",
            alarm: alarm,
            timestamp: timestamp,
            monday: this.state.monday,
            tuesday: this.state.tuesday,
            wednesday: this.state.wednesday,
            thursday: this.state.thursday,
            friday: this.state.friday,
            saturday: this.state.saturday,
            sunday: this.state.sunday
          });
        } else {
          let alarm = i.toString();
          alarmTimes.push({
            user_id: user_id,
            label: "",
            alarm: alarm,
            timestamp: timestamp,
            monday: this.state.monday,
            tuesday: this.state.tuesday,
            wednesday: this.state.wednesday,
            thursday: this.state.thursday,
            friday: this.state.friday,
            saturday: this.state.saturday,
            sunday: this.state.sunday
          });
        }
      }
      alarmTimes.map(alarm => console.log("alarm map", alarm));
      //alarmTimes.map(alarm => this.props.addAlarms(alarm));
      //this.props.history.push("/homepage/alarms");
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
      timestamp: timestamp,
      monday: this.state.monday,
      tuesday: this.state.tuesday,
      wednesday: this.state.wednesday,
      thursday: this.state.thursday,
      friday: this.state.friday,
      saturday: this.state.saturday,
      sunday: this.state.sunday
    }

    this.props.addAlarms(alarmBody);
    console.log("alarm body: ", "alarm", alarm, "label", label);
  };

  render() {
    return (
      <div className="alarms-container">
        <div className="home-container">
          <div className="sidebar">
            <Link to="/homepage" style={{ textDecoration: "none" }}>
              <h2 className="titlelinks">Home</h2>
            </Link>
            <Link to="/homepage/recipes" style={{ textDecoration: "none" }}>
              <h2 className="titlelinks">Recipes</h2>
            </Link>
            <Link to="/homepage/alarms" style={{ textDecoration: "none" }}>
              <h2 className="titlelinks">Alarms</h2>
            </Link>
            <Link to="/homepage/meals" style={{ textDecoration: "none" }}>
              <h2 className="titlelinks">Meals</h2>
            </Link>
            <Link to="/homepage/billing" style={{ textDecoration: "none" }}>
              <h2 className="titlelinks">Billing</h2>
            </Link>
            <Link to="/homepage/settings" style={{ textDecoration: "none" }}>
              <h2 className="titlelinks">Settings</h2>
            </Link>
            <Button color="danger" onClick={this.toggle}>
              Log Out
            </Button>
            <Link to="homepage/billing">
              <Button className="danger" color="danger">
                Upgrade to Premium
              </Button>
            </Link>
          </div>

          <div className="dynamic-display">
            <div className="alarm-days">
              <h3>Which days should the alarm(s) apply to?</h3>
              <input
                type="checkbox"
                name="monday"
                value="monday"
                defaultChecked={this.state.monday}
                onChange={() => this.handleCheck("monday")}
              />{" "}
              Monday
              <input
                type="checkbox"
                name="tuesday"
                value="tuesday"
                defaultChecked={this.state.tuesday}
                onChange={() => this.handleCheck("tuesday")}
              />{" "}
              Tuesday
              <input
                type="checkbox"
                name="wednesday"
                value="wednesday"
                defaultChecked={this.state.wednesday}
                onChange={() => this.handleCheck("wednesday")}
              />{" "}
              Wednesday
              <input
                type="checkbox"
                name="thursday"
                value="thursday"
                defaultChecked={this.state.thursday}
                onChange={() => this.handleCheck("thursday")}
              />{" "}
              Thursday
              <input
                type="checkbox"
                name="friday"
                value="friday"
                defaultChecked={this.state.friday}
                onChange={() => this.handleCheck("friday")}
              />{" "}
              Friday
              <input
                type="checkbox"
                name="saturday"
                value="saturday"
                defaultChecked={this.state.saturday}
                onChange={() => this.handleCheck("saturday")}
              />{" "}
              Saturday
              <input
                type="checkbox"
                name="sunday"
                value="sunday"
                defaultChecked={this.state.sunday}
                onChange={() => this.handleCheck("sunday")}
              />{" "}
              Sundays
            </div>
            <div className="add-container">
              <h1>Add Alarms in a Batch</h1>
              <form className="forms">
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

            <div className="add-container">
              <h1>Add a Single Alarm</h1>
            </div>
            <form>
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
