import React, { Component } from "react";
import { Link } from "react-router-dom";


class Alarm extends Component {
  render() {
    return (
      <div className="alarm-container">
        <h2>{alarm}</h2>
        <h2>{label}</h2>
      </div>
    )
  }
}

export default Alarm;