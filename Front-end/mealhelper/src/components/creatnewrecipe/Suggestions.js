import React, { Component } from "react";
import "../recipes/recipes.css";
class Suggestions extends Component {
  render() {
    return (
      <div className="results-item">
        <p>{this.props.name}</p>
      </div>
    );
  }
}

export default Suggestions;
