import React, { Component } from "react";
import { connect } from "react-redux";
import {
  Button,
  Modal,
  ModalHeader,
  ModalBody,
  ModalFooter,
  UncontrolledDropdown,
  DropdownToggle,
  DropdownMenu,
  DropdownItem
} from "reactstrap";
//change the route for this
import { addMeal } from "../../store/actions/mealActions";
import { withRouter, Link, Route } from "react-router-dom";
// import { Alert } from "reactstrap";
import Recipes from "../recipes/recipes";
import axios from "axios";
import "./meals.css";

class Meals extends Component {
  constructor(props) {
    super(props);

    this.state = {
      modal: false,
      dropdownOpen: false,
      recipes: [],
      zip: "",
      meals: [],
      recipe: [],
      mealTime: "",
      experience: [],
      date: "",
      notes: "",
      servings: "",
      modalLogout: false,
      name: "",
      temp: null,
      humidity: null,
      pressure: null
    };
    this.toggle = this.toggle.bind(this);
  }
  ///converted to Imperial measurement
  componentDidMount(props) {
    if (localStorage.getItem("token")) {
      const id = localStorage.getItem("user_id");
      axios
        .get(`https://labs8-meal-helper.herokuapp.com/recipe/user/${id}`)
        .then(recipess => {
          this.setState({ recipes: recipess.data });
        })
        .catch(err => {
          console.log(err);
        });

      this.setState({ zip: this.props.user.zip });
      this.componentGetMeals();
    } else {
      this.props.history.push("/");
    }
  }

  componentGetMeals() {
    const id = localStorage.getItem("user_id");
    axios
      .get(`https://labs8-meal-helper.herokuapp.com/users/${id}/meals`)
      .then(meals => {
        console.log(meals);
        this.setState({ meals: meals.data });
      })
      .catch(err => {
        console.log(err);
      });
    console.log(this.state.meals);
  }
  // componentWillReceiveProps(nextProps) {
  //   console.log("im in component did recieve props");
  //   console.log(nextProps);
  // }

  toggle() {
    console.log(this.props);
    console.log(this.state.meals);
    this.setState({
      modal: !this.state.modal
    });
  }
  toggleDropDown() {
    this.setState(prevState => ({
      dropdownOpen: !prevState.dropdownOpen
    }));
  }
  chooseMeal(meal) {
    console.log(meal);
    this.setState({ mealTime: meal });
  }
  chooseExperience(mood) {
    console.log(mood);
    this.setState({ experience: mood });
  }
  saveMeal = event => {
    event.preventDefault();

    const user_id = localStorage.getItem("user_id");
    const recipe_id = this.state.recipe.id;
    const {
      mealTime,
      experience,
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
      mealTime,
      experience,
      date,
      notes,
      name,
      temp,
      humidity,
      pressure,
      recipe_id,
      servings
    };
    this.props.addMeal(meal);
    this.toggle();
  };
  chooseRecipe = recipe => {
    console.log(recipe);
    this.setState({ recipe: recipe });
  };
  handleChange = event => {
    event.preventDefault();
    this.setState({
      [event.target.name]: event.target.value
    });
  };
  toggleLogout = () => {
    this.setState({
      modalLogout: !this.state.modalLogout
    });
  };
  logout = event => {
    event.preventDefault();
    localStorage.removeItem("token");
    localStorage.removeItem("user_id");
    this.props.history.push("/");
  };
  getWeatherZip = event => {
    event.preventDefault();
    const zip = `${this.state.zip}`;
    console.log(zip);
    axios
      .get(
        `https://api.openweathermap.org/data/2.5/weather?zip=${zip}&units=imperial&appid=418e2edbbd08e52ca4eb31f0e5b1e300`
      )
      .then(response => {
        console.log(response);
        this.setState({
          name: response.data.name,
          temp: response.data.main.temp,
          humidity: response.data.main.humidity,
          pressure: response.data.main.pressure
        });
      })
      .catch(error => {
        console.log("Error", error);
      });
  };

  render() {
    return (
      <div className="home-container">
        {/* <div className="sidebar">
          <Link to="/homepage" style={{ textDecoration: "none" }}>
            <h2 className="titlelinks">Home</h2>
          </Link>
          <Link to="/homepage/recipes" style={{ textDecoration: "none" }}>
            <h2 className="titlelinks">Recipes</h2>
          </Link>
          <Link to="/homepage/alarms" style={{ textDecoration: "none" }}>
            <h2 className="titlelinks">Alarms</h2>
          </Link>
          <Link to="/homepage/meals" style={{ textDecoration: "none" }}>
            <h2 className="titlelinks">Meals</h2>
          </Link>
          <Link to="/homepage/billing" style={{ textDecoration: "none" }}>
            <h2 className="titlelinks">Billing</h2>
          </Link>
          <Link to="/homepage/settings" style={{ textDecoration: "none" }}>
            <h2 className="titlelinks">Settings</h2>
          </Link>
          <Button color="danger" onClick={this.toggleLogout}>
            Log Out
          </Button>
        </div> */}
        <div className="create-recipe-background">
          <Button color="success" onClick={this.toggle}>
            + New Meal
          </Button>
          <Modal
            isOpen={this.state.modal}
            toggle={this.toggle}
            className={this.props.className}
          >
            <ModalHeader toggle={this.toggle}>New Meal</ModalHeader>
            <ModalBody>
              <p>Date:</p>
              <form>
                <input
                  id="date"
                  className="date-meal"
                  type="date"
                  name="date"
                  onChange={this.handleChange}
                  value={this.state.date}
                  placeholder=" / /"
                />
              </form>
            </ModalBody>
            <ModalBody>
              <p>Servings:</p>
              <form>
                <input
                  id="servings"
                  className="date-meal"
                  type="number"
                  name="servings"
                  onChange={this.handleChange}
                  value={this.state.servings}
                  placeholder=""
                />
              </form>
            </ModalBody>
            <ModalBody>Recipe: {this.state.recipe.name}</ModalBody>
            <UncontrolledDropdown>
              <DropdownToggle caret>Dropdown</DropdownToggle>
              <DropdownMenu>
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
            <ModalBody>Which meal was this? {this.state.mealTime}</ModalBody>
            <UncontrolledDropdown>
              <DropdownToggle caret>Dropdown</DropdownToggle>
              <DropdownMenu>
                <DropdownItem onClick={() => this.chooseMeal("Breakfast")}>
                  Breakfast
                </DropdownItem>
                <DropdownItem onClick={() => this.chooseMeal("Lunch")}>
                  Lunch
                </DropdownItem>
                <DropdownItem onClick={() => this.chooseMeal("Dinner")}>
                  Dinner
                </DropdownItem>
                <DropdownItem onClick={() => this.chooseMeal("Snack")}>
                  Snack
                </DropdownItem>
              </DropdownMenu>
            </UncontrolledDropdown>
            <ModalBody>
              How was the experience? {this.state.experience}
            </ModalBody>
            <UncontrolledDropdown>
              <DropdownToggle caret>Dropdown</DropdownToggle>
              <DropdownMenu>
                <DropdownItem onClick={() => this.chooseExperience("😁")}>
                  😁
                </DropdownItem>
                <DropdownItem onClick={() => this.chooseExperience("😐")}>
                  😐
                </DropdownItem>
                <DropdownItem onClick={() => this.chooseExperience("😰")}>
                  😰
                </DropdownItem>
                <DropdownItem onClick={() => this.chooseExperience("🤢")}>
                  🤢
                </DropdownItem>
              </DropdownMenu>
            </UncontrolledDropdown>
            <ModalBody>
              <p>Notes:</p>
              <form>
                <input
                  id="notes"
                  className="notes-meal"
                  type="text"
                  name="notes"
                  onChange={this.handleChange}
                  value={this.state.notes}
                  placeholder="Notes. . ."
                />
              </form>
            </ModalBody>
            <ModalBody>
              <p>Weather:</p>
              <p>City: {this.state.name},</p>
              <p>Temp: {this.state.temp} °F</p>
              <p>Humidity: {this.state.humidity}</p>
              <p>Pressure: {this.state.pressure}</p>
              <button onClick={this.getWeatherZip}>Get Weather</button>
            </ModalBody>
            <ModalFooter>
              <Button color="success" onClick={this.saveMeal}>
                Save Meal
              </Button>{" "}
              <Button color="secondary" onClick={this.toggle}>
                Cancel
              </Button>
            </ModalFooter>
          </Modal>
        </div>
        <div className="mealList-Display">
          {/* {this.state.meals.map(meal => (
						<OneMeal
							meal={meal}
							mealTime={meal.mealTime}
							experience={meal.experience}
							date={meal.date}
						/>
					))} */}
        </div>
        <Modal
          isOpen={this.state.modalLogout}
          toggle={this.toggleLogout}
          className={this.props.className}
        >
          <ModalHeader toggle={this.toggleLogout}>
            Do you wish to log out?
          </ModalHeader>
          <Button onClick={this.logout} color="danger">
            Log out
          </Button>
          <Button onClick={this.toggleLogout} color="primary">
            Cancel
          </Button>
        </Modal>
      </div>
    );
  }
}

const mapStateToProps = state => ({
  user: state.userReducer.user,
  meals: state.mealsReducer.meals,
  recipes: state.recipesReducer.recipes
});

export default connect(
  mapStateToProps,
  { addMeal }
)(withRouter(Meals));
