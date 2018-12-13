import React, { Component } from "react";
import { connect } from "react-redux";
import { addRecipe, getRecipe } from "../../store/actions/recipeActions.js";
import { addMultipleNutrients } from "../../store/actions/nutrientsActions";
import { addMultipleIngredients } from "../../store/actions/ingredActions";
import { withRouter, Link } from "react-router-dom";
import axios from "axios";
import Suggestions from "./Suggestions";
import GetNutrients from "./GetNutrients";
import InfiniteScroll from "react-infinite-scroll-component";
import DisplayNutrients from "./DisplayNutrients";
import DisplayFoodName from "./DisplayFoodName";
import "../recipes/recipes.css";

class SearchFood extends Component {
  constructor(props) {
    super(props);

    this.state = {
      query: "",
      typing: false,
      message: "",
      nutrients: [],
      results: [],
      food: [],
      calories: 0,
      total: 0,
      number: 50,
      limitIndex: 50
    };
    this.saveRecipe = this.saveRecipe.bind(this);
    this.saveRecipeIngredients = this.saveRecipeIngredients.bind(this);
    this.saveRecipeNutrition = this.saveRecipeNutrition.bind(this);
  }

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
    console.log(food);
    axios
      .get(
        `https://api.nal.usda.gov/ndb/nutrients/?format=json&api_key=c24xU3JZJhbrgnquXUNlyAGXcysBibSmESbE3Nl6&nutrients=208&nutrients=203&nutrients=204&nutrients=205&ndbno=${
          food.ndbno
        }`
      )
      .then(response => {
        if (response.data.errors) {
          this.setState({
            nutrients: ["Could not find nutrients with that name"]
          });
        } else {
          this.setState({
            nutrients: [
              ...this.state.nutrients,
              response.data.report.foods[0].nutrients
            ]
          });
          console.log(this.state.nutrients);
        }
      });

    console.log(this.state.food);
  };

  removeItem = itemIndex => {
    console.log(this.state.food);
    const filteredFoods = this.state.food.filter(
      (item, idx) => itemIndex !== idx
    );
    const filteredNutrients = this.state.nutrients.filter(
      (item, idx) => itemIndex !== idx
    );
    this.setState({ food: filteredFoods, nutrients: filteredNutrients });
    console.log(filteredFoods);
  };
  // removeNutrients = nutrientIndex => {
  //   const filteredFoods = this.state.food.filter(
  //     (item, idx) => itemIndex !== idx
  //   );
  // }
  addNutrients = nutrients => {
    this.setState({ nutrients: nutrients });
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

  async saveRecipe(event, props) {
    event.preventDefault();
    console.log(JSON.stringify(this.state.nutrients));
    let sumCalories = 0;
    for (let i = 0; i < this.state.nutrients.length; i++) {
      if (this.state.nutrients[i][0]) {
        let nutrientsJSON = JSON.stringify(
          parseInt(this.state.nutrients[i][0].value, 10)
        );

        sumCalories += parseInt(nutrientsJSON, 10);
      }
    }

    this.setState({ calories: sumCalories });

    const { calories } = this.state;
    const { name, servings } = this.props;
    const recipe = { name, calories, servings };
    const id = localStorage.getItem("user_id");
    const data = await this.props.addRecipe(recipe, id);
    console.log("Recipe promise is:" + data);
    // console.log("this is the count of ingredients array", countIngredients);
    this.saveRecipeIngredients();
  }

  async saveRecipeIngredients(props) {
    let countIngredients = this.state.food.length;
    console.log(this.props);
    let recipe_ids = this.props.recipes.pop();
    console.log(recipe_ids.id);
    const recipeID = recipe_ids.id;
    const id = localStorage.getItem("user_id");
    console.log("this is my user ID: " + id);
    const data = await this.props.addMultipleIngredients(
      this.state.food,
      id,
      countIngredients,
      recipeID
    );
    console.log("Ingredients promise is:" + data);
    this.saveRecipeNutrition();
  }
  async saveRecipeNutrition() {
    const id = localStorage.getItem("user_id");
    let recipe_ids = this.props.recipes.pop();

    const recipeID = recipe_ids.id;

    let countNutrients = this.state.nutrients.length;
    const data = await this.props.addMultipleNutrients(
      this.state.nutrients,
      id,
      countNutrients,
      recipeID
    );
    this.props.history.push("/homepage");
  }

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
                addNutrients={this.addNutrients}
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
              addNutrients={this.addNutrients}
            />
          ))}
        </div>
        <div className="recipe-save-button">
          <button className="save-recipe-button" onClick={this.saveRecipe}>
            {" "}
            Save Recipe
          </button>
        </div>
        <table className="nutrients-container">
          <tr className="first-nutrients-header-div">
            <th className="nutrient-header-name">
              <h3>Food Name</h3>
            </th>
            <th className="nutrient-header">
              <h3>Calories</h3>
            </th>
            <th className="nutrient-header">
              <h3>Proteins</h3>
            </th>
            <th className="nutrient-header">
              <h3>Carbs</h3>
            </th>
            <th className="nutrient-header-last">
              <h3>Fats</h3>
            </th>
          </tr>
          <tr className="nutrients-display-table">
            <th>
              {this.state.food.map(food => (
                <DisplayFoodName key={food.id} name={food.name} />
              ))}
            </th>
            <tr>
              {this.state.nutrients.map(index => (
                <th className="first-nutrients-header-nutrients">
                  {index.map(ingredient => (
                    <DisplayNutrients
                      key={ingredient.id}
                      value={ingredient.value}
                      unit={ingredient.unit}
                    />
                  ))}
                </th>
              ))}
            </tr>
          </tr>
        </table>
      </form>
    );
  }
}

const mapStateToProps = state => {
  return {
    user: state.userReducer.user,
    meals: state.mealsReducer.meals,
    recipes: state.recipesReducer.recipes,
    ingredients: state.ingredsReducer.ingredient,
    nutrients: state.nutrientsReducer.nutrients
  };
};

export default connect(
  mapStateToProps,
  { addRecipe, addMultipleNutrients, addMultipleIngredients }
)(withRouter(SearchFood));
