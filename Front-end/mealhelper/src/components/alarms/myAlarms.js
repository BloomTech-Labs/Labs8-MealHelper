import React, { Component } from "react";
import { connect } from "react-redux";
import { Link, withRouter } from "react-router-dom";
import axios from "axios";
import { fetchAlarms, deleteAlarm, updateAlarm } from "../../store/actions/alarmActions";
//import { Alarm } from "./alarm";
import Select from "react-select";
import editAlarmModal from './editAlarmModal';
import {
  Button,
  Modal,
  ModalHeader,
  ModalBody,
  ModalFooter,
  UncontrolledDropdown,
  DropdownToggle,
  DropdownMenu,
  DropdownItem
} from "reactstrap";

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
        label: '',
        alarm: ''
      },
      label: ''
    };
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
    console.log(this.state.label);
 };

 handleChange = event => {
  event.preventDefault();
  this.setState({
    [event.target.name]: event.target.value
  });
};

 sendToEdit(label) {
  
  this.setState(prevState => ({
    ...this.state,
    alarmToUpdate: {
      ...prevState.alarmToUpdate,
      label: label
    }
   }), 
   () => this.props.updateAlarm(this.state.alarmToUpdate),
   () => console.log("send to Edit, alarmToUpdate", this.state.alarmToUpdate) )
}


 showModal = (alarmID) => {
  // if (this.state.show) {
  //   this.setState ({
  //     show: !this.state.show,
  //   })
  // } else {
  const alarmToUpdate = this.props.alarms.find(alarm => alarm.id === alarmID);
  this.setState ({
    ...this.state,
    show: !this.state.show,
    alarmToUpdate: alarmToUpdate
  }, () => console.log("ALARM TO UPDATE", this.state.alarmToUpdate))
//}
}

  render() {
  
    return (
     
      <div className="alarms-container">
        <div className="home-container">
          <div className="sidebar"><Link to="/homepage" style={{ textDecoration: "none" }}>
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
          </Link></div>

          <div className="dynamic-display">
          <h1>Alarms</h1>
          <Link to="/homepage/alarms/add-alarms">Add New Alarms</Link>
              {this.props.alarms.map((alarm) => (
            <div 
              key={alarm.id}
              id={alarm.id}
              label={alarm.label}
              alarm={alarm.alarm}
              // onClick={() => this.props.history.push(`alarm/${alarm.id}`)}              
              > <br/>
              <h2>{alarm.alarm}</h2>
              <h2>{alarm.label}</h2>
              <button onClick={() => this.showModal(alarm.id)}> Edit </button>
              <button onClick={() => this.props.deleteAlarm(alarm.id)}>Delete</button>
              </div>
              ))}
            
            <editAlarmModal show={this.state.show}>
                
                <div className="edit-modal">
                <h2>Edit Alarm</h2>
                <input
                type="label"
                name="label"
                value={this.state.label}
                onChange={this.handleChange}></input>
                 <Select
              options={options}
              className="time"
              name="alarmTime"
              onChange={opt => this.setState(prevState => ({
                alarmToUpdate: {
                    ...prevState.alarmToUpdate,
                    alarm: opt.value
                }
              }))}
            />
                <button onClick={() => this.sendToEdit(this.state.label)}>Submit</button>
                <button onClick={() => this.showModal}>Nevermind</button>
                </div>
            
            </editAlarmModal>
          </div>
        </div>
      </div>
    );
  }
}

const mapStateToProps = state => ({
  alarms: state.alarmsReducer.alarms,
  alarm: state.alarmsReducer.alarm,
  user: state.userReducer.user
})

export default connect(
  mapStateToProps,
  { fetchAlarms, deleteAlarm, updateAlarm }
)(withRouter(MyAlarms));