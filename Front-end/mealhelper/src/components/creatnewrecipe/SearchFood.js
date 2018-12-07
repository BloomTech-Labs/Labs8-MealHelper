import React, { Component } from "react";
import axios from "axios";
import Suggestions from "./Suggestions";
import "../recipes/recipes.css";

class Search extends Component {
  state = {
    query: "",
    typing: false,
    message: "",
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

        console.log(this.state.message);
      });
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
      <form>
        <input
          type="search"
          name="query"
          id="Search"
          className="search-food"
          placeholder="Search for Ingredients. . ."
          // ref={input => (this.search = input)}
          onChange={this.handleInputChange}
          value={this.state.query}
        />

        <div
          className={this.state.typing ? "results-data" : "results-data-hidden"}
        >
          {this.state.results.map(food => (
            <Suggestions
              id={food.ndbno}
              message={food}
              food={food}
              name={food.name}
            />
          ))}
        </div>
      </form>
    );
  }
}

export default Search;
