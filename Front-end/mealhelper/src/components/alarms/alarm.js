import React, { Component } from "react";
import { Link } from "react-router-dom";


class Alarm extends Component {
  render() {
    return (
      <div className="label">
        <h2>{label}</h2>
        <h3>{alarm}</h3>
      </div>
    )
  }
}

export default Alarm;
