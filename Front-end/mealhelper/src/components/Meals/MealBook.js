// == Dependencies == //
import React, { Component } from "react";
import { connect } from "react-redux";
import { withRouter } from "react-router-dom";
import axios from "axios";
// == Actions == //
import { getMeals, changeMeal } from "../../store/actions/mealActions";
import { getRecipe } from "../../store/actions/recipeActions";
// == Styles == //
import "./mealbook.css";

const meals = [
  {
    id: 1,
    user_id: 1,
    mealTime: "Breakfast",
    experience: "good",
    name: "Basic Morning Breakfast",
    temp: null,
    humidity: null,
    pressure: null,
    notes: "a delicious meal",
    date: "01/01/2018",
    servings: 1,
    recipe_id: 1
  },
  {
    id: 2,
    user_id: 1,
    mealTime: "Lunch",
    experience: "",
    name: "Caramel Everything",
    temp: null,
    humidity: null,
    pressure: null,
    notes: "oof ouch owie my teeth",
    date: "01/01/2018",
    servings: 123,
    recipe_id: 2
  }
];

const recipes = [
  {
    id: 1,
    name: "Eggs and Bacon",
    calories: 400,
    servings: 1,
    user_id: 1
  },
  {
    id: 2,
    name: "Caramel Popcorn",
    calories: 300,
    servings: 1,
    user_id: 1
  }
];

class MealBook extends Component {
  constructor(props) {
    super(props);
    this.state = {
      experience: "",
      recipes: [],
      recipe: [],
      ingredients: [],
      nutrition: []
    };
  }

  componentDidMount() {
    // let userID = this.props.user.id;
    let userID = localStorage.getItem("user_id");
    this.props.getMeals(userID);
    this.props.getRecipe(userID);
    console.log("this.props.user", this.props.user, "meals", this.props.meals);
  }

  componentDidUpdate(prevProps) {
    // let userID = this.props.user.userID;
    let userID = localStorage.getItem("user_id");
    if (JSON.stringify(this.props.meals) !== JSON.stringify(prevProps.meals)) {
      this.props.getMeals(userID);
    }
    if (
      JSON.stringify(this.props.recipes) !== JSON.stringify(prevProps.recipes)
    ) {
      this.props.getRecipe(userID);
    }
  }

  getRecipeName(recipeID) {
    console.log("RECIPES", this.props.recipes);
    let recipes = this.props.recipes;
    let oneRecipe = recipes.find(recipe => recipe.id === recipeID);
    console.log("oneRecipe", oneRecipe);
    if (oneRecipe) return oneRecipe.name;
    return "...";
  }

  getNutrients(recipeID, nutr) {
    if (recipeID) {
      axios
        .get(
          `https://labs8-meal-helper.herokuapp.com/ingredients/recipe/${recipeID}`
        )
        .then(response => {
          // this.setState({ ingredients: response.data });
          axios
            .get(
              `https://labs8-meal-helper.herokuapp.com/nutrients/${recipeID}`
            )
            .then(response => {
              this.setState({ nutrition: response.data }, () =>
                console.log("nutrition", this.state.nutrition)
              );
            });
        });

      let nutrition = this.state.nutrition;
      if (nutr === "cal") {
        let calories = nutrition.filter(
          nutr => nutr.nutrient === "Energy"
        );
        let calTotal = calories.reduce((cal, nutrient) => {
          return (cal += Number(nutrient.value));
        }, 0);
        console.log("calTotal", calTotal);
        return Math.round(calTotal);
      }
    }
  }

  updateExperience(mealID, experience) {
    const mealToUpdate = this.props.meals.find(meal => meal.id === mealID);
    const mealBody = { ...mealToUpdate, experience: experience };
    this.props.changeMeal(mealBody);
  }

  singleMealView(mealID) {
    this.props.history.push(`homepage/meals/mealbook/${mealID}`);
  }

  render() {
    const meals = this.props.meals;
    return (
      <div className="mealbook-full-width">
        <div className="mealbook-container">
          <div className="mealbook-heading">
            <h1>Meals</h1>
          </div>

          {meals.length ? (
            meals.map(meal => (
              <div className="mealbook-card" key={meal.id} id={meal.id}>
                {" "}
                <br />
                <div
                  className="mealbook-text"
                  onClick={() =>
                    this.props.history.push(
                      `/homepage/meals/mealbook/${meal.id}`
                    )
                  }
                >
                  <div className="mealbook-card-sec1">
                    <div className="mealbook-date">
                      <p>{meal.date}</p>
                    </div>
                    <div className="mealbook-time">
                      <p>{meal.mealTime}</p>
                    </div>
                  </div>
                  <div className="mealbook-card-sec2">
                    <div className="mealbook-name">
                      <p>{this.getRecipeName(meal.recipe_id)}</p>
                    </div>
                    <div className="mealbook-serve">
                      <p>{meal.servings} servings</p>
                    </div>
                  </div>
                </div>
                {/* <div className="mealbook-nutr">
                  <p>Calories: {this.getNutrients(meal.recipe_id, "cal")}</p>
                  <p>Protein: {this.protein(meal.recipe_id)}</p>
                  <p>Carbs: {this.carbs(meal.recipe_id)}</p>
                  <p>Fat: {this.fat(meal.recipe_id)}</p>
                </div> */}
                <div className="mealbook-exp">
                  <p>Experience:</p>
                  <div className="mealbook-buttons">
                    <button
                      className={
                        meal.experience === "good"
                          ? "mealbook-btn-active"
                          : "mealbook-btn-inactive"
                      }
                      onClick={() => this.updateExperience(meal.id, "good")}
                    >
                      👍
                    </button>
                    <button
                      className={
                        meal.experience === "bad"
                          ? "mealbook-btn-active"
                          : "mealbook-btn-inactive"
                      }
                      onClick={() => this.updateExperience(meal.id, "bad")}
                    >
                      👎
                    </button>
                  </div>
                </div>
              </div>
            ))
          ) : (
            <div className="meal-card empty">
              <div className="meal-text empty">You don't have any Meals.</div>
            </div>
          )}
        </div>
        <div className="add-new-mb">
          <button
            className="add-new-mb-btn"
            onClick={() => this.props.history.push("/homepage/meals/new")}
          >
            <h3>Add New Meal</h3>
          </button>
        </div>
      </div>
    );
  }
}

const mapStateToProps = state => ({
  meals: state.mealsReducer.meals,
  singleMeal: state.mealsReducer.meal,
  recipes: state.recipesReducer.recipes,
  user: state.userReducer.user
});

export default connect(
  mapStateToProps,
  { getMeals, changeMeal, getRecipe }
)(withRouter(MealBook));
