import React, { Component } from "react";
import "../recipes/recipes.css";
function DisplayNutrients(props) {
  if (props.message === "Could not find foods with that name") {
    return <p>{props.message}</p>;
  } else {
    return (
      <div className="nutrient-value">
        <h3>
          {props.value}
          {props.unit}
        </h3>
      </div>
    );
  }
}

export default DisplayNutrients;
