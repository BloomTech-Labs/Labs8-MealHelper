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

  addFood = food => {
    this.setState({ food: [...this.state.food, food] });
    console.log(this.state.food);
  };

  handleInputChange = event => {
    event.preventDefault();

    this.setState(
      {
        [event.target.name]: event.target.value
      },
      () => {
        if (this.state.query) {
          this.setState({ typing: true });
          this.getInfo();
        }
        if (this.state.query === "") {
          this.setState({ typing: false });
        }
      }
    );
  };

  render() {
    return (
      <div>
        <div>{this.props.id}</div>
        <div>{this.props.name}</div>
      </div>
    );
  }
}

export default Search;
