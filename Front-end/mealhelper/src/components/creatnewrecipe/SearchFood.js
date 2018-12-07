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
    number: 50,
    limitIndex: 50
  };

  getInfo = () => {
    axios
      .get(
        `https://api.nal.usda.gov/ndb/search/?format=json&It=f&q=${
          this.state.query
        }&sort=n&max=${
          this.state.number
        }&offset=0&api_key=c24xU3JZJhbrgnquXUNlyAGXcysBibSmESbE3Nl6`
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
    const oldCount = this.state.number;
    this.setState({ number: this.state.number + 100 });
    const newCount = this.state.number;
    axios
      .get(
        `https://api.nal.usda.gov/ndb/search/?format=json&It=f&q=${
          this.state.query
        }&sort=n&max=${
          this.state.number
        }&offset=0&api_key=c24xU3JZJhbrgnquXUNlyAGXcysBibSmESbE3Nl6`
      )
      .then(response => {
        console.log(response);
        if (response.data.errors) {
          this.setState({ results: ["Could not find foods with that name"] });
        } else {
          this.setState({
            results: this.state.results.concat(
              response.data.list.item.slice(oldCount, newCount)
            )
          });
        }
        console.log(this.state.results);
      });
    console.log("im in fetchmoreData!");

    console.log(this.state.limitIndex);
  };
  addFood = food => {
    this.setState({
      food: [...this.state.food, food],

      limitIndex: 50
    });
    console.log(this.state.food);
  };

  removeItem = itemIndex => {
    console.log(this.state.food);
    const filteredFoods = this.state.food.filter(
      (item, idx) => itemIndex !== idx
    );
    this.setState({ food: filteredFoods });
    console.log(filteredFoods);
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
            {this.state.results.map(food => (
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
          {this.state.food.map((food, index) => (
            <GetNutrients
              index={index}
              offset={food.offset}
              id={food.ndbno}
              remove={this.removeItem}
              name={food.name}
            />
          ))}
        </div>
      </form>
    );
  }
}

export default Search;
