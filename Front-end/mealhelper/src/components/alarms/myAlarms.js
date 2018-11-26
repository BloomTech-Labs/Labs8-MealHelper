import React, { Component } from "react";
import { connect } from "react-redux";
import { withRouter } from "react-router-dom";
//import actions

class MyAlarms extends Component {
  constructor(props) {
    super(props);

    this.state = {
      alarmsList: []
    };
  }

  componentDidMount() {
    //establish user id
    //get alarms
  }

  componentWillReceiveProps(nextProps) {
    //update list of alarms
  }

  render() {
    return (
      <div className="alarms-container">
        <div className="home-container">
          <div className="sidebar">
    {/* sidebar stuff */}
          </div>

          <div className="dynamic-display">
            {/* map out list of alarms */}
          </div>
        </div>
      </div>
      
    )
  }
  
}

const mapStateToProps = state => ({
  // state to be mapped
})

export default connect(
  mapStateToProps,
  // alarm action
)(withRouter(MyAlarms));
