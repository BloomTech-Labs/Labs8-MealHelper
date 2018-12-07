import React, { Component } from "react";
import { withRouter } from "react-router-dom";
import Knife from "../../img/knife (1).svg";
import Fork from "../../img/fork (1).svg";
import Plate from "../../img/plate (1).svg";
import { connect } from "react-redux";
import "./table.css";
import TweenLite from "./action";

class Knifer extends Component {
  componentDidMount() {
    TweenLite.to(this.knife, 1, { x: 100, y: 100 });
  }
  render() {
    return (
      <div className="table-is-set">
        <img
          ref={div => (this.knife = div)}
          src={Knife}
          alt="This is a knife....trust me."
        />
        <img className="plate" src={Plate} alt="This is a plate...trust me." />
        <img className="fork" src={Fork} alt="This is a fork...trust me." />
      </div>
    );
  }
}

export default connect()(withRouter(Knifer));
