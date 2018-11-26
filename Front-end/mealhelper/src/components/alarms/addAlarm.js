import React, { Component } from "react";
import { connect } from "react-redux";
import { withRouter } from "react-router-dom"
//import moment from "moment";
import Select from "react-select";
// import actions

//this is embarrassingly not DRY; auto-populate ASAP
const options = [
  { value: 100, label: '1:00 AM' },
  { value: 200, label: '2:00 AM' },
  { value: 300, label: '3:00 AM' },
  { value: 400, label: '4:00 AM' },
  { value: 500, label: '5:00 AM' },
  { value: 600, label: '6:00 AM' },
  { value: 700, label: '7:00 AM' },
  { value: 800, label: '8:00 AM' },
  { value: 900, label: '9:00 AM' },
  { value: 1000, label: '10:00 AM' },
  { value: 1100, label: '11:00 AM' },
  { value: 1200, label: '12:00 PM' },
  { value: 1300, label: '1:00 PM' },
  { value: 1400, label: '2:00 PM' },
  { value: 1500, label: '3:00 PM' },
  { value: 1600, label: '4:00 PM' },
  { value: 1700, label: '5:00 PM' },
  { value: 1800, label: '6:00 PM' },
  { value: 1900, label: '7:00 PM' },
  { value: 2000, label: '8:00 PM' },
  { value: 2100, label: '9:00 PM' },
  { value: 2200, label: '10:00 PM' },
  { value: 2300, label: '11:00 PM' },
  { value: 2400, label: '12:00 AM (midnight)' },
]

class AddAlarms extends Component {
  constructor(props) {
    super(props);

    this.state = {
      beginTime: null,
      endTime: null,
      repeats: null
    }
  }

  handleChange = event => {
    event.preventDefault();
    this.setState({
      [event.target.name]: event.target.value
    });
  };

  dropDownState = opt => {
    this.setState({ beginTime: opt })
  }

  addAlarm = event => {
    event.preventDefault();
    console.log("hello!")
    console.log("start time", this.state.beginTime)
    console.log("end time", this.state.endTime)
    console.log("hours between", this.state.repeats)
    //make sure all required fields are filled in
    //get fields from state
    //assign values to alarm body
    //pass alarm body to addAlarm actions
    //this.props.history.push to alarms list
  }


  //convert beginTime and endTime to military time
  //calculate how many alarms between beginTime and endTime using repeats
  //take amount of alarms and insert bulk data to database

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
        //onChange={startOpt => console.log("start time", startOpt.label, startOpt.value)}
        onChange={opt => this.setState({ beginTime: opt.value })}
         />
          {/* <input
            className="time"
            name="beginTime"
            value={this.state.beginTime}
            onChange={this.handleChange}
            placeholder="Beginning Time"
          /> */}
        <Select 
        options={options}
        className="time"
        name="endTime"
        placeholder="End Time"
        onChange={opt => this.setState({ endTime: opt.value })}
        />
          {/* <input
            className="time"
            name="endTime"
            value={this.state.endTime}
            onChange={this.handleChange}
            placeholder="Ending Time"
          /> */}
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
