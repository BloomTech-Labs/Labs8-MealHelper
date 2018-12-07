import React, { Component } from "react";
import axios from "axios";
import Suggestions from "./Suggestions";
import "../recipes/recipes.css";

class Search extends Component {
  state = {
    query: "",
    results: []
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

        console.log(this.state.results);
      });
  };

  handleInputChange = event => {
    event.preventDefault();
    this.setState(
      {
        [event.target.name]: event.target.value
      },
      () => {
        if (this.state.query && this.state.query.length > 1) {
          if (this.state.query.length % 2 === 0) {
            this.getInfo();
          }
        }
      }
    );
  };

  render() {
    return (
      <form>
        <input
          type="search"
          name="query"
          className="search-food"
          placeholder="Search for..."
          // ref={input => (this.search = input)}
          onChange={this.handleInputChange}
          value={this.state.query}
        />

        <div className="results-data">
          {this.state.results.map(food => (
            <Suggestions id={food.ndbno} food={food} name={food.name} />
          ))}
        </div>
      </form>
    );
  }
}

export default Search;
