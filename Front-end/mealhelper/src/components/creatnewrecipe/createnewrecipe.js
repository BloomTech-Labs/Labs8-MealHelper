import React, { Component } from "react";
import { connect } from "react-redux";
//change the route for this
import axios from "axios";
import { addRecipe, getRecipe } from "../../store/actions/recipeActions.js";
import { withRouter } from "react-router-dom";
import Nutrients from "../recipes/Nutrients";
import FoodSearch from "../recipes/FoodSearch";
import "../recipes/recipes.css";

class CreateNewRecipe extends Component {
  constructor(props) {
    super(props);

    this.state = {
      list: [],
      selectedFoods: [],
      ingredients: [],
      search: "",
      name: "",
      calories: 0,
      serving: 1,
      ndbno: null,
      modal: false,
      modalLogout: false,
      nutrients: []
    };
    this.addFood = this.addFood.bind(this);
  }

  toggle = () => {
    this.setState({
      modal: !this.state.modal
    });
  };
  componentDidMount() {
    if (localStorage.getItem("token")) {
      const id = localStorage.getItem("user_id");
      this.props.getRecipe(id);
    } else {
      this.props.history.push("/");
    }
  }

  settingState() {
    this.setState({ list: this.props.recipes });
  }

  handleChange = event => {
    event.preventDefault();
    this.setState({
      [event.target.name]: event.target.value
    });
  };

  handleSubmit = event => {
    event.preventDefault();
    const user_id = this.props.user.userID;
    const ingredient_id = this.state.ingredients.id;
    const { name, calories, servings } = this.state;
    const recipe = {
      user_id,
      ingredient_id,
      name,
      calories,
      servings
    };
    this.props.addRecipe(recipe);
  };

  saveItem = (item, event) => {
    console.log(event);
    event.preventDefault();
    const { manu, ndbno } = item;
    const ingredient = { manu, ndbno };
    this.setState({
      ingredients: ingredient
    });
  };

  removeFoodItem = itemIndex => {
    const filteredFoods = this.state.selectedFoods.filter(
      (item, idx) => itemIndex !== idx
    );
    this.setState({ selectedFoods: filteredFoods });
  };
  nutrientsGrabber = () => {
    const foodArray = this.state.selectedFoods;

    for (let i = 0; i < foodArray.length; i++) {
      axios
        .get(
          `https://api.nal.usda.gov/ndb/nutrients/?format=json&api_key=c24xU3JZJhbrgnquXUNlyAGXcysBibSmESbE3Nl6&nutrients=208&nutrients=203&nutrients=204&nutrients=205&ndbno=${
            foodArray[i].ndbno
          }`
        )
        .then(response => {
          this.setState({
            nutrients: [...this.state.nutrients, response.data.report.foods[0]]
          });
        });
    }
  };
  async addFood(food) {
    this.state.selectedFoods.push(food);
    console.log(this.state.selectedFoods);

    const data = await this.nutrientsGrabber();
  }

  saveCalories = caloriesTotal => {
    this.setState({ calories: caloriesTotal });
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
  render() {
    const { selectedFoods } = this.state;
    return (
      <div className="recipe-container">
        <div className="new-recipe-holder">
          <form onSubmit={this.handleSubmit}>
            <div className="recipe-input-1">
              <h1 className="new-meal-text-new">Create A New Recipe</h1>
              <input
                id="name"
                className="name-recipe"
                type="text"
                name="name"
                onChange={this.handleChange}
                value={this.state.name}
                placeholder="Recipe Name"
              />
              <br />
              <br />

              <FoodSearch onFoodClick={this.addFood} />
            </div>

            <div className="recipe-nutrients-info">
              <div>
                {console.log(this.state.nutrients)}
                <Nutrients
                  logoutModal={this.state.modal}
                  logoutMethod={this.toggle}
                  name={this.state.name}
                  calories={this.state.calories}
                  servings={this.state.serving}
                  setCalories={this.saveCalories}
                  foods={this.state.nutrients}
                  onFoodClick={this.removeFoodItem}
                />
              </div>
            </div>
            <br />
          </form>
        </div>
      </div>
    );
  }
}

const mapStateToProps = state => {
  return {
    user: state.userReducer.user,
    recipe: state.recipesReducer.recipe
  };
};

export default connect(
  mapStateToProps,
  { addRecipe, getRecipe }
)(withRouter(CreateNewRecipe));
