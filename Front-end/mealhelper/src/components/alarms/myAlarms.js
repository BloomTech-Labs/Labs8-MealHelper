import React, { Component } from "react";
import { connect } from "react-redux";
import { Link, withRouter } from "react-router-dom";
import axios from "axios";
import { fetchAlarms } from "../../store/actions"
//import { Alarm } from "./alarm";

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
]

class MyAlarms extends Component {
  constructor(props) {
    super(props);

    this.state = {
      alarmsList: []
    };
  }

  componentDidMount() {

    this.setState({ alarmsList: this.alarms })
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
             {alarms.map((alarm) => (
            <div
              key={alarm.id}
              id={alarm.id}
              label={alarm.label}
              alarm={alarm.alarm}              
              > <br/>
              <h2>{alarm.alarm}</h2>
              <h2>{alarm.label}</h2></div>
              ))} 
            
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
