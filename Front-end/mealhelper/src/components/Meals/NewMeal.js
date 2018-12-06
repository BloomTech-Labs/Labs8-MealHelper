import React, { Component } from "react";
import { connect } from "react-redux";
//change the route for this
import { addMeal } from "../../store/actions/mealActions";
import { addWeather } from "../../store/actions/weatherActions";
import { withRouter, Link, Route } from "react-router-dom";
import {
  Dropdown,
  DropdownMenu,
  DropdownToggle,
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
      mealName: "",
      date: "",
      notes: "",
      weather: {},
      servings: 1,
      mealType: "Meal Type",
      dropdownOpen: false
    };
    this.toggle = this.toggle.bind(this);
  }
  addNewMeal = () => {
    const recipe_id = this.state.recipe.id;
    const user_id = localStorage.getItem("user_id");
    const {
      mealType,
      date,
      notes,
      mealName,
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
      mealName,
      temp,
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
    const zip = this.props.user.zip;
    axios
      .get(
        `https://api.openweathermap.org/data/2.5/weather?zip=${zip},us&appid=418e2edbbd08e52ca4eb31f0e5b1e300`
      )
      .then(response => {
        console.log(response.data);
        // this.setState({ weather: response.data });
      });
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
          <form>
            <div>
              <input
                className="new-meal-text-enter"
                type="text"
                onChange={this.handleChange}
                value={this.state.mealName}
                name="mealName"
                placeholder="Enter Meal Name. . ."
              />
            </div>
            <div>
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
              <input
                className="new-meal-text-servings"
                type="number"
                onChange={this.handleChange}
                value={this.state.servings}
                name="servings"
                placeholder="Servings. . ."
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
                Weather +
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
