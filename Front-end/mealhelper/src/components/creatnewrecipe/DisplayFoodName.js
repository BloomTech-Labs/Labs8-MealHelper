import React, { Component } from "react";
import "../recipes/recipes.css";
function DisplayFoodName(props) {
  if (props.message === "Could not find foods with that name") {
    return <p>{props.message}</p>;
  } else {
    return (
      <div className="first-nutrients-header">
        <p className="display-food-name">{props.name}</p>
      </div>
    );
  }
}

export default DisplayFoodName;
