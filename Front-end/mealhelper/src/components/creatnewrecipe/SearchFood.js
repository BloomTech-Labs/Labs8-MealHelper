import React, { Component } from "react";
import axios from "axios";
import Suggestions from "./Suggestions";
import GetNutrients from "./GetNutrients";
import InfiniteScroll from "react-infinite-scroll-component";
import "../recipes/recipes.css";

class Search extends Component {
  state = {
    query: "",
    typing: false,
    message: "",
    results: [],
    food: [],
    total: 0,
    limitIndex: 50
  };

  getInfo = () => {
    axios
      .get(
        `https://api.nal.usda.gov/ndb/search/?format=json&It=f&q=${
          this.state.query
        }&sort=n&max=1000&offset=0&api_key=c24xU3JZJhbrgnquXUNlyAGXcysBibSmESbE3Nl6`
      )
      .then(response => {
        console.log(response);
        if (response.data.errors) {
          this.setState({ results: ["Could not find foods with that name"] });
        } else {
          this.setState({
            results: response.data.list.item,
            total: response.data.list.total
          });
        }
        console.log(this.state.results.length);
      });
  };
  fetchMoreData = () => {
    console.log("im in fetchmoreData!");
    this.setState({ limitIndex: this.state.limitIndex + 50 });
    console.log(this.state.limitIndex);
  };
  addFood = food => {
    this.setState({
      food: [...this.state.food, food],
      typing: false,
      limitIndex: 50
    });
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
          id="scrollableDiv"
          className={this.state.typing ? "results-data" : "results-data-hidden"}
        >
          <InfiniteScroll
            dataLength={this.state.results.length}
            next={this.fetchMoreData}
            hasMore={true}
            loader={<h4>Loading...</h4>}
            scrollableTarget="scrollableDiv"
          >
            {this.state.results.slice(0, this.state.limitIndex).map(food => (
              <Suggestions
                total={this.state.total}
                id={food.ndbno}
                addFood={this.addFood}
                message={food}
                food={food}
                name={food.name}
              />
            ))}
          </InfiniteScroll>
        </div>
        <div className="selected-ingredients">
          {this.state.food.slice(0, this.state.limitIndex).map(food => (
            <GetNutrients id={food.ndbno} name={food.name} />
          ))}
        </div>
      </form>
    );
  }
}

export default Search;
