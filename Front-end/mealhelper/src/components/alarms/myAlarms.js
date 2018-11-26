import React, { Component } from "react";
import { connect } from "react-redux";
//import actions

class MyAlarms extends Component {
  constructor(props) {
    super(props);

    this.state = {

    };
  }

  componentDidMount() {
    //establish user id
    //get alarms
  }

  componentWillReceiveProps(nextProps) {
    //update list of alarms
  }

  
}

const mapStateToProps = state => ({
  // state to be mapped
})

export default connect(
  mapStateToProps,
  // alarm action
)(withRouter(Alarms));
)