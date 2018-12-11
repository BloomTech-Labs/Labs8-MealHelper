import React, { Component } from "react";
import axios from "axios";
import Suggestions from "./Suggestions";
import GetNutrients from "./GetNutrients";
import "../recipes/recipes.css";

class Search extends Component {
  state = {
    query: "",
    typing: false,
    message: "",
    results: [],
    food: []
  };

  getInfo = () => {
    axios
      .get(
        `https://api.nal.usda.gov/ndb/search/?format=json&It=f&q=${
          this.state.query
        }&sort=n&max=10&offset=0&api_key=c24xU3JZJhbrgnquXUNlyAGXcysBibSmESbE3Nl6`
      )
      .then(response => {
        console.log(response);
        if (response.data.errors) {
          this.setState({ results: ["Could not find foods with that name"] });
        } else {
          this.setState({ results: response.data.list.item });
        }

        console.log(this.state.message);
      });
  };

  render() {
    console.log(this.props);
    return (
      <div
        className="individual-ingredient"
        onClick={() => this.props.remove(this.props.index)}
      >
        <div>{this.props.name}</div>
      </div>
    );
  }
}

export default Search;
