import React, { Component } from "react";
import "../recipes/recipes.css";
function Suggestions(props) {
  console.log(props);
  if (props.message === "Could not find foods with that name") {
    return <p>{props.message}</p>;
  } else {
    return <p>{props.name}</p>;
  }
}

export default Suggestions;
