import React, { Component } from "react";
import { connect } from "react-redux";
import { Link, withRouter } from "react-router-dom";
import axios from "axios";
//import { fetchAlarms } from "../../store/actions"
//import { Alarm } from "./alarm";

class MyAlarms extends Component {
  constructor(props) {
    super(props);

    this.state = {
      alarmsList: []
    };
  }

  componentDidMount() {
  //  this.props.fetchAlarms();
  }

  componentWillReceiveProps(nextProps) {
    //update list of alarms
  }
;
  render() {
    return (
      <div className="alarms-container">
        <div className="home-container">
          <div className="sidebar">
    {/* sidebar stuff */}
          </div>

          <div className="dynamic-display">
          <h1>Alarms</h1>
          <Link to="alarms/add-alarms">Add New Alarms</Link>
            {/* {this.props.alarms.map((alarm) => (
            <div
              key={alarm.id}
              id={alarm.id}
              label={alarm.label}
              alarm={alarm.alarm}              
              />
              ))} */}
            
          </div>
        </div>
      </div>
      
    )
  }
  
}

const mapStateToProps = state => ({
  alarms: state.alarms
})

export default connect(
  mapStateToProps
//  { fetchAlarms }
)(withRouter(MyAlarms));
