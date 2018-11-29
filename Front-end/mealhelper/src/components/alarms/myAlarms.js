import React, { Component } from "react";
import { connect } from "react-redux";
import { Link, withRouter } from "react-router-dom";
import axios from "axios";
import { fetchAlarms, deleteAlarm } from "../../store/actions/alarmActions";
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

    // this.state = {
    //   alarmsList: []
    // };
  }

  componentDidMount() {
    console.log("this.props", this.props);
    let userID = this.props.user.userID;
    console.log("this.props.user.userID", this.props.user.userID)
    this.props.fetchAlarms(userID);
    console.log("this.props.alarms", this.props.alarms)
  }

  componentDidUpdate(prevProps) {
    console.log("in componentDidUpdate");
    let userID = this.props.user.userID;
    if(JSON.stringify(this.props.alarms) !== JSON.stringify(prevProps.alarms)) {
        this.props.fetchAlarms(userID);
        console.log("this.props.alarms", this.props.alarms)
    }
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
          <Link to="/homepage/alarms/add-alarms">Add New Alarms</Link>
              {this.props.alarms.map((alarm) => (
            <div 
              key={alarm.id}
              id={alarm.id}
              label={alarm.label}
              alarm={alarm.alarm}
              //onClick={() => this.props.history.push(`alarm/${alarm.id}`)}              
              > <br/>
              <h2>{alarm.alarm}</h2>
              <h2>{alarm.label}</h2>
              <button onClick={() => this.props.deleteAlarm(alarm.id)}>Delete</button>
              </div>
              ))}
            
          </div>
        </div>
      </div>
      
    )
  }
  
}

const mapStateToProps = state => ({
  alarms: state.alarmsReducer.alarms,
  user: state.userReducer.user
})

export default connect(
  mapStateToProps,
  { fetchAlarms, deleteAlarm }
)(withRouter(MyAlarms));
