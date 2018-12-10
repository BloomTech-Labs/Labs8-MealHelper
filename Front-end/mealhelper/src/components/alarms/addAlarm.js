// == Dependencies == //
import React, { Component } from "react";
import { connect } from "react-redux";
import { withRouter } from "react-router-dom";
import Select from "react-select";
import { 
  Button,
  UncontrolledDropdown,
  DropdownToggle,
  DropdownMenu,
  DropdownItem 
} from "reactstrap";
// == Actions == //
import { addAlarms } from "../../store/actions/alarmActions";
// == Styles == //
import "./addAlarm.css";

//this is embarrassingly not DRY; auto-populate ASAP
const customStyles = {
  control: (provided,) => ({
    // none of react-select's styles are passed to <Control />
    ...provided,
    width: 200,
  })
}


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

  chooseStartTime(value) {
    console.log("CHOOSE START TIME VALUE", value);
    this.setState({ startTime: value }, () => console.log("chooseStartTime setstate", this.state.startTime))
  }

  chooseEndTime(value) {
    console.log("CHOOSE END TIME VALUE", value);
    this.setState({ endTime: value }, () => console.log("chooseEndTime setstate", this.state.endTime))
  }

  chooseAlarmTime(value) {
    console.log("CHOOSE ALARM TIME VALUE", value);
    this.setState({ alarmTime: value }, () => console.log("chooseAlarmTime setstate", this.state.alarmTime))
  }

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
      alarmTimes.map(alarm => console.log("BATCH ALARMS", alarm))
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
    console.log("SINGLE ALARM", alarmBody)
    this.props.addAlarms(alarmBody);
    this.props.history.push("/homepage/alarms");
  };

  militaryToStandard = time => {
    let twelve = 0;
    let format = 0;
    let twelveWithZero = 0;
    let lastNum = 0;
    if (time > 1259) {
      twelve = time - 1200;
      if (twelve > 3) {
        if (twelve >= 1000) {
          format = twelve.toString().split("")
          lastNum = format[format.length - 1]
          format[2] = ":";
          format.push(lastNum, " PM")
          return format.join("")
        }
        
        twelveWithZero = 0 + twelve.toString();
        format = twelveWithZero.toString().split("");
        lastNum = format[format.length - 1];
        format[2] = ":";
        format.push(lastNum, " PM");
        return format.join("");
      }
    }
    format = time.split("");
    lastNum = format[format.length - 1];
    format[2] = ":";
    format.push(lastNum, " AM");
    return format.join("");
  };

  render() {
    return (
      <div className="add-alarms-container">
        <div className="add-alarms-forms-bg">
        <div className="add-alarms-content">
          <div className="add-alarms-heading">
            <h1>Add Alarms in a Batch</h1>
          </div>
          <form className="add-alarm-inputs">
           <div>First Alarm: {this.state.startTime ? this.militaryToStandard(this.state.startTime) : null}</div>
            <UncontrolledDropdown>
              <DropdownToggle className="choose-alarm" caret>
                Choose first alarm time
              </DropdownToggle>
                <DropdownMenu className="choose-alarm-dropdown"
                modifiers={{
                  setMaxHeight: {
                    enabled: true,
                    order: 890,
                    fn: (data) => {
                      return {
                        ...data,
                        styles: {
                          ...data.styles,
                          overflow: 'auto',
                          maxHeight: 200,
                        },
                      };
                    },
                  },
                }}>
                  {options.map(opt => (
                    <DropdownItem
                      opt={opt.value}
                      name={opt.name}
                      onClick={() => this.chooseStartTime(opt.value)}>
                    {opt.label}
                    </DropdownItem>
                  ))}
                </DropdownMenu>

            </UncontrolledDropdown>
            <div>Last Alarm: {this.state.endTime ? this.militaryToStandard(this.state.endTime) : null}</div>
            <UncontrolledDropdown>
              <DropdownToggle className="choose-alarm" caret>
                Choose last alarm time
              </DropdownToggle>
                <DropdownMenu className="choose-alarm-dropdown"
                modifiers={{
                  setMaxHeight: {
                    enabled: true,
                    order: 890,
                    fn: (data) => {
                      return {
                        ...data,
                        styles: {
                          ...data.styles,
                          overflow: 'auto',
                          maxHeight: 200,
                        },
                      };
                    },
                  },
                }}>
                  {options.map(opt => (
                    <DropdownItem
                      opt={opt.value}
                      name={opt.name}
                      onClick={() => this.chooseEndTime(opt.value)}>
                    {opt.label}
                    </DropdownItem>
                  ))}
                </DropdownMenu>

            </UncontrolledDropdown>
            <div>Hours Between Each Alarm</div>
            <input
              className="repeats"
              name="repeats"
              value={this.state.repeats}
              onChange={this.handleChange}
            />
          </form>
          <div>Tip: You can add labels to your alarms by clicking 'Edit' next to each alarm on the Alarms page.</div>
          <Button color="info" onClick={this.addAlarm} className="add-alarms-btn">
            Add Alarm Batch
          </Button>
          </div>
        </div>

        <div className="add-alarms-forms-bg">
        <div className="add-alarms-content">
          <div className="add-alarms-heading">
            <h1>Add a Single Alarm</h1>
          </div>
          <form className="add-alarm-inputs">
          <div>Alarm Time: {this.state.alarmTime ? this.militaryToStandard(this.state.alarmTime) : null}</div>
          <UncontrolledDropdown>
              <DropdownToggle className="choose-alarm" caret>
                Choose alarm time
              </DropdownToggle>
                <DropdownMenu className="choose-alarm-dropdown"
                  modifiers={{
                    setMaxHeight: {
                      enabled: true,
                      order: 890,
                      fn: (data) => {
                        return {
                          ...data,
                          styles: {
                            ...data.styles,
                            overflow: 'auto',
                            maxHeight: 200,
                          },
                        };
                      },
                    },
                  }}>
                  {options.map(opt => (
                    <DropdownItem
                      opt={opt.value}
                      name={opt.name}
                      onClick={() => this.chooseAlarmTime(opt.value)}>
                    {opt.label}
                    </DropdownItem>
                  ))}
                </DropdownMenu>

            </UncontrolledDropdown>
            <div>Label</div>
            <input
              className="label"
              name="label"
              value={this.state.label}
              onChange={this.handleChange}
            />
          </form>
          <Button color="info" onClick={this.addSingleAlarm} className="add-alarms-btn">
            Add Alarm
          </Button>
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
