import React, { Component } from "react";
import { connect } from "react-redux";
//change the route for this
import { addMeal } from "../../store/actions/mealActions";
import { addWeather } from "../../store/actions/weatherActions";
import { withRouter, Link, Route } from "react-router-dom";

import {
  Dropdown,
  UncontrolledDropdown,
  DropdownToggle,
  DropdownMenu,
  DropdownItem
} from "reactstrap";
// import { Alert } from "reactstrap";
import Recipes from "../recipes/recipes";
import axios from "axios";
import "./meals.css";

class Meals extends Component {
  constructor(props) {
    super(props);

    this.state = {
      recipes: [],
      mealName: "",
      addWeatherButton: "Weather +",
      date: "",
      notes: "",
      weather: {},
      temp: null,
      humidity: null,
      pressure: null,
      name: "",
      servings: 1,
      mealType: "Meal Type",
      dropdownOpen: false
    };
    this.toggle = this.toggle.bind(this);
  }
  componentDidMount(props) {
    console.log(this.props.user.zip);
    const id = this.props.user.userID;
    axios
      .get(`https://labs8-meal-helper.herokuapp.com/recipe/user/${id}`)
      .then(recipess => {
        this.setState({ recipes: recipess.data });
      })
      .catch(err => {
        console.log(err);
      });
  }

  addNewMeal = () => {
    const recipe_id = this.state.recipe.id;
    const user_id = localStorage.getItem("user_id");
    const {
      mealType,
      date,
      notes,
      name,
      temp,
      humidity,
      pressure,
      servings
    } = this.state;
    const meal = {
      user_id,
      mealType,
      date,
      notes,
      temp,
      name,
      humidity,
      pressure,
      recipe_id,
      servings
    };
    this.props.addMeal(meal);
  };
  toggle() {
    this.setState({
      dropdownOpen: !this.state.dropdownOpen
    });
  }
  addWeather = event => {
    event.preventDefault();
    console.log(this.props.user);
    const zip = this.props.user.zip;
    axios
      .get(
        `https://api.openweathermap.org/data/2.5/weather?zip=${zip}&units=imperial&appid=418e2edbbd08e52ca4eb31f0e5b1e300`
      )
      .then(response => {
        console.log(response.data);
        this.setState({
          name: response.data.name,
          temp: response.data.main.temp,
          humidity: response.data.main.humidity,
          pressure: response.data.main.pressure,
          addWeatherButton: "Temp: " + response.data.main.temp + "°F"
        });
        // this.setState({ weather: response.data });
      });
  };
  chooseRecipe = recipe => {
    console.log(recipe);
    this.setState({ recipe: recipe });
  };
  selectMealType = mealType => {
    this.setState({ mealType: mealType });
  };
  handleChange = event => {
    event.preventDefault();
    this.setState({
      [event.target.name]: event.target.value
    });
  };
  render() {
    return (
      <div className="meals-container">
        <div className="meal-box-new">
          <h1 className="new-meal-text-new">Create A New Meal</h1>
          <p className="new-meal-text-new-help">Need Help?</p>
          <form>
            <div>
              <UncontrolledDropdown>
                <DropdownToggle className="choose-recipe" caret>
                  Choose Recipe
                </DropdownToggle>
                <DropdownMenu className="choose-recipe-dropdown">
                  {this.state.recipes.map(recipe => (
                    <DropdownItem
                      recipe={recipe}
                      name={recipe.name}
                      onClick={() => this.chooseRecipe(recipe)}
                    >
                      {recipe.name}
                    </DropdownItem>
                  ))}
                </DropdownMenu>
              </UncontrolledDropdown>
            </div>
            <div className="meal-box-new-input">
              <input
                className="new-meal-text-date"
                type="date"
                onChange={this.handleChange}
                value={this.state.date}
                name="date"
                placeholder="Date"
              />
            </div>
            <div>
              <input
                className="new-meal-text-servings"
                type="number"
                onChange={this.handleChange}
                value={this.state.servings}
                name="servings"
                placeholder="Add Recipe"
              />
            </div>

            <div>
              <textarea
                className="new-meal-text-servings-notes"
                type="number"
                onChange={this.handleChange}
                value={this.state.notes}
                name="notes"
                placeholder="Notes. . ."
              />
            </div>
            <div className="Drop">
              <div>
                <Dropdown
                  className="new-meal-experience"
                  isOpen={this.state.dropdownOpen}
                  toggle={this.toggle}
                >
                  <DropdownToggle
                    className="span-toggle"
                    tag="span"
                    onClick={this.toggle}
                    data-toggle="dropdown"
                    aria-expanded={this.state.dropdownOpen}
                  >
                    <p className="text-span">{this.state.mealType}</p>
                  </DropdownToggle>
                  <DropdownMenu>
                    <DropdownItem
                      onClick={() => {
                        this.selectMealType("Breakfast");
                      }}
                    >
                      Breakfast
                    </DropdownItem>
                    <DropdownItem
                      onClick={() => {
                        this.selectMealType("Lunch");
                      }}
                    >
                      Lunch
                    </DropdownItem>
                    <DropdownItem
                      onClick={() => {
                        this.selectMealType("Dinner");
                      }}
                    >
                      Dinner
                    </DropdownItem>
                    <DropdownItem
                      onClick={() => {
                        this.selectMealType("Dessert");
                      }}
                    >
                      Dessert
                    </DropdownItem>
                  </DropdownMenu>
                </Dropdown>
              </div>

              <button
                onClick={this.addWeather}
                className="button-new-meal-experience"
              >
                <p className="weather-return-text">
                  {this.state.addWeatherButton}
                </p>
              </button>
            </div>
          </form>
          <button
            onClick={this.addNewMeal}
            className="button-new-meal-experience"
          >
            Save Meal
          </button>
        </div>
      </div>
    );
  }
}

const mapStateToProps = state => ({
  user: state.userReducer.user,
  meals: state.mealsReducer.meals,
  recipes: state.recipesReducer.recipes,
  weather: state.weatherReducer.weather
});

export default connect(
  mapStateToProps,
  { addMeal, addWeather }
)(withRouter(Meals));
