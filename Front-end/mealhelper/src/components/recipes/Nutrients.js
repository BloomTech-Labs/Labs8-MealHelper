import React, { Component } from "react";
import { connect } from "react-redux";
//change the route for this
import { addMultipleIngredients } from "../../store/actions/ingredActions.js";
import { addMultipleNutrients } from "../../store/actions/nutrientsActions";
import { addRecipe } from "../../store/actions/recipeActions";
import { withRouter, Link, Route } from "react-router-dom";
// import { Alert } from "reactstrap";
import { Button } from "reactstrap";
import axios from "axios";
import Recipe from "./recipe";
import "./recipes.css";

class Nutrients extends Component {
  constructor(props) {
    super(props);

    this.state = {
      selectedFoods: [],
      nutrients: []
    };
    this.saveRecipe = this.saveRecipe.bind(this);
    this.saveRecipeIngredients = this.saveRecipeIngredients.bind(this);
  }
  componentWillReceiveProps(nextProps) {
    this.setState({ selectedFoods: nextProps.selectedFoods });
  }
  handleChange = event => {
    event.preventDefault();
    this.setState({
      [event.target.name]: event.target.value
    });
  };

  addNutrients = event => {
    event.preventDefault();
    const selectedFood = this.state.selectedFoods;

    selectedFood.map((nutrient_id, index) => {
      axios
        .get(
          `https://api.nal.usda.gov/ndb/nutrients/?format=json&api_key=c24xU3JZJhbrgnquXUNlyAGXcysBibSmESbE3Nl6&nutrients=208&nutrients=203&nutrients=204&nutrients=205&ndbno=${
            nutrient_id.ndbno
          }`
        )
        .then(response => {
          this.setState({
            nutrients: [...this.state.nutrients, response.data.report.foods[0]]
          });
        });
    });
  };
  async saveRecipe(event, props) {
    event.preventDefault();
    const { name, calories, servings } = this.props;
    const recipe = { name, calories, servings };
    const data = await this.props.addRecipe(recipe, this.props.user.userID);
    console.log(data);
    // console.log("this is the count of ingredients array", countIngredients);
    this.saveRecipeIngredients();
  }

  async saveRecipeIngredients(props) {
    let countIngredients = this.state.selectedFoods.length;
    let recipe_ids = this.props.recipes.pop();
    console.log(recipe_ids);
    const data = await this.props.addMultipleIngredients(
      this.state.selectedFoods,
      this.props.user.userID,
      countIngredients,
      recipe_ids.id
    );
    console.log(data);

    this.saveRecipeNutrition();
  }

  saveRecipeNutrition = () => {
    const nutrients = this.state.nutrients.map(nutrient => {
      return nutrient.nutrients;
    });
    let countNutrients = nutrients.length;
    this.props.addMultipleNutrients(
      nutrients,
      this.props.user.userID,
      countNutrients,
      this.props.ingredients
    );
  };
  removeFoodItem = itemIndex => {
    const filteredFoods = this.state.nutrients.filter(
      (item, idx) => itemIndex !== idx
    );
    console.log(filteredFoods);
    this.setState({ nutrients: filteredFoods });
  };

  sumKCAL = (foods, prop) => {
    console.log(prop);

    return foods
      .reduce((memo, food) => parseInt(food.nutrients[0].value, 10) + memo, 0.0)
      .toFixed(0);
  };
  sumProtein = (foods, prop) => {
    console.log(prop);
    return foods
      .reduce((memo, food) => parseFloat(food.nutrients[1].value) + memo, 0.0)
      .toFixed(2);
  };
  sumFat = (foods, prop) => {
    console.log(prop);
    return foods
      .reduce(
        (memo, food) => parseFloat(food.nutrients[2].value, 10) + memo,
        0.0
      )
      .toFixed(2);
  };
  sumCarb = (foods, prop) => {
    console.log(prop);
    return foods
      .reduce(
        (memo, food) => parseFloat(food.nutrients[3].value, 10) + memo,
        0.0
      )
      .toFixed(2);
  };
  render(props) {
    const foodRows = this.state.nutrients.map((food, idx) => (
      <tr
        food={food}
        key={food.offset}
        name={food.name}
        kcal={food.nutrients[0].value}
        protein_g={food.nutrients[1].value}
        fat_g={food.nutrients[2].value}
        carbohydrate_g={food.nutrients[3].value}
        onClick={() => this.removeFoodItem(idx)}
      >
        <td>{food.name}</td>
        <td className="right aligned">{food.nutrients[0].value + "Cal"}</td>
        <td className="right aligned">{food.nutrients[1].value + "g"}</td>
        <td className="right aligned">{food.nutrients[2].value + "g"}</td>
        <td className="right aligned">{food.nutrients[3].value + "g"}</td>
      </tr>
    ));
    return (
      <div className="weather-container">
        <div>
          <table className="ui selectable structured large table">
            <thead>
              <tr>
                <th colSpan="5">
                  <h3>Nutrients</h3>
                </th>
              </tr>
              <tr>
                <th />

                <th>Kcal</th>

                <th>Protein (g)</th>
                <th>Fat (g)</th>
                <th>Carbs (g)</th>
              </tr>
            </thead>
            <tbody>{foodRows}</tbody>
            <tfoot>
              <tr>
                <th>Total</th>

                <th className="right aligned" id="total-kcal">
                  {this.sumKCAL(this.state.nutrients, "kcal") + "Cal"}{" "}
                  {this.props.setCalories(
                    this.sumKCAL(this.state.nutrients, "kcal")
                  )}
                </th>
                <th className="right aligned" id="total-protein_g">
                  {this.sumProtein(this.state.nutrients, "protein_g") + "g"}
                </th>
                <th className="right aligned" id="total-fat_g">
                  {this.sumFat(this.state.nutrients, "fat_g") + "g"}
                </th>
                <th className="right aligned" id="total-carbohydrate_g">
                  {this.sumCarb(this.state.nutrients, "carbohydrate_g") + "g"}
                </th>
              </tr>
            </tfoot>
          </table>
        </div>
        <br /> <br />
        <button onClick={this.addNutrients}>Apply Selected Foods</button>
        <br /> <br />
        <br /> <br />
        <Button color="success" onClick={this.saveRecipe}>
          Save Recipe
        </Button>{" "}
        <Button color="secondary" onClick={this.props.logoutMethod}>
          Cancel
        </Button>
      </div>
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
)(withRouter(Nutrients));
