// == Dependencies == //
import React, { Component } from "react";
import { connect } from "react-redux";
import { withRouter } from "react-router-dom";
import axios from "axios";
// == Actions == //
import { getMeal, changeMeal } from "../../store/actions/mealActions";
// == Styles == //
import "./singlemeal.css";

class SingleMeal extends Component {
  constructor(props) {
    super(props);
    this.state = {
      meal: {
        id: 1,
        user_id: 1,
        mealTime: "Breakfast",
        experience: "",
        temp: null,
        humidity: null,
        pressure: null,
        notes: "a delicious meal",
        date: "01/01/2018",
        servings: 1,
        recipe_id: 1
      },
      recipe: {},
      ingredients: [],
      nutrition: []
    };
  }

  componentDidMount() {
    let userID = this.props.user.id;
    let { mealID } = this.props.match.params;
    this.props.getMeal(mealID, userID);
    console.log("MEALID", mealID, "USERID", userID);
    console.log("single meal on props", this.props.singleMeal);
    this.getNutrients();
  }

  componentDidUpdate(prevProps, prevState) {
    let userID = this.props.user.id;
    let { mealID } = this.props.match.params;
    if (JSON.stringify(this.props.singleMeal) !== JSON.stringify(prevProps.singleMeal)) {
      this.props.getMeal(mealID, userID);
      this.getNutrients();
    }
    if (JSON.stringify(this.state.recipe) !== JSON.stringify(prevState.recipe)
    || JSON.stringify(this.state.ingredients) !== JSON.stringify(prevState.ingredients)
    || JSON.stringify(this.state.nutrition) !== JSON.stringify(prevState.nutrition)) {
      this.getNutrients();
    }
  }

  getNutrients() {
    if(this.props.singleMeal) {
    axios
      .get(
        `https://labs8-meal-helper.herokuapp.com/recipe/single/${this.props.singleMeal.recipe_id}`
      )
      .then(response => {
        this.setState({ recipe: response.data });
        const recipe_id = this.state.recipe.id;

        axios
          .get(
            `https://labs8-meal-helper.herokuapp.com/ingredients/recipe/${recipe_id}`
          )
          .then(response => {
            this.setState({ ingredients: response.data });
            axios
              .get(
                `https://labs8-meal-helper.herokuapp.com/nutrients/${recipe_id}`
              )
              .then(response => {
                this.setState({ nutrition: response.data }, () => console.log("nutrition", this.state.nutrition))
              });
          });
      });
    }
  }

  calories() {
    //pull all objects where nutrient === Energy
   // const calories = this.state.nutrition.find(nutr => nutr.nutrient === "Energy");
    let calories = this.state.nutrition.filter(nutr => nutr.nutrient === "Energy");
    let calTotal = calories.reduce((cal, nutrient) => {
      return cal += Number(nutrient.value)
    }, 0);
    console.log("calTotal", calTotal);
    return calTotal;
    //return obj.value
  }

  protein() {
    //pull all objects where nutrient === Protein
    //return obj.value
    let protein = this.state.nutrition.filter(nutr => nutr.nutrient === "Protein");
    let proTotal = protein.reduce((cal, nutrient) => {
      return cal += Number(nutrient.value)
    }, 0);
    console.log("prTotal", proTotal);
    return proTotal;
  }

  carbs() {
    //pull all objects where nutrient === Carbohydrate, by difference
    //return obbj.value
    let carbs = this.state.nutrition.filter(nutr => nutr.nutrient === "Carboyhydrate, by difference");
    let carbTotal = carbs.reduce((cal, nutrient) => {
      return cal += Number(nutrient.value)
    }, 0);
    console.log("carbTotal", carbTotal);
    return carbTotal;
  }

  fat() {
//pull all objects where nutrient === Total lipid (fat)
    //return obj.value
    let fat = this.state.nutrition.filter(nutr => nutr.nutrient === "Total lipid (fat)");
    let fatTotal = fat.reduce((cal, nutrient) => {
      return cal += Number(nutrient.value)
    }, 0);
    console.log("fatTotal", fatTotal);
    return fatTotal;
  }

  render() {
    const meal = this.props.singleMeal;
    const recipe = this.state.recipe;
    return (
      <div className="single-meal-full-width">
        <div className="single-meal-container">
          <div className="single-meal-bg">
            <div className="single-meal-content">

              {meal
              ?
              <div>
              <div className="single-meal-heading">
                <div className="sm-top">
                  <h1>{meal.mealTime}</h1>
                </div>
                <div className="sm-bottom">
                  <h3>{meal.date}</h3>
                  <div className="sm-exp-buttons">
                    <button
                      className={
                        meal.experience === "good"
                          ? "mealbook-btn-active"
                          : "mealbook-btn-inactive"
                      }
                      onClick={() =>
                        this.setState(prevState => ({
                          meal: {
                            ...prevState.meal,
                            experience: "good"
                          }
                        }))
                      }
                    >
                      👍
                    </button>
                    <button
                      className={
                        meal.experience === "bad"
                          ? "mealbook-btn-active"
                          : "mealbook-btn-inactive"
                      }
                      onClick={() =>
                        this.setState(prevState => ({
                          meal: {
                            ...prevState.meal,
                            experience: "bad"
                          }
                        }))
                      }
                    >
                      👎
                    </button>
                  </div>
                </div>
              </div>
              <div className="single-meal-details">
                <div className="sm-details-top">
                  <p className="sm-recipe-name">{recipe.name}</p>
                  <p className="sm-servings">
                    {meal.servings}{" "}
                    {meal.servings.length > 1 ? "servings" : "serving"}
                  </p>
                </div>
                <div className="sm-details-middle">
                  <table className="sm-nutrients-container">
                    <tr className="sm-nutr-header-first">
                      <th className="sm-nutrient-header">
                        <p>Calories</p>
                      </th>
                      <th className="sm-nutrient-header">
                        <p>Protein</p>
                      </th>
                      <th className="sm-nutrient-header">
                        <p>Carbs</p>
                      </th>
                      <th className="sm-nutrient-header-last">
                        <p>Fat</p>
                      </th>
                    </tr>
                    <tr>
                      <td>{this.calories()} g</td>
                      <td>{this.protein()} g</td>
                      <td>{this.carbs()} g</td>
                      <td>{this.fat()} g</td>
                    </tr>
                  </table>
                </div>
                <div className="sm-details-bottom">
                  <div className="sm-notes">
                    <h3>Notes</h3>
                    {meal.notes}
                  </div>
                  <div className="sm-weather">
                    <h3>Weather</h3>
                    {meal.temp ? 
                    <div>
                    <p>Temp: {meal.temp}</p>
                    <p>Humidity: {meal.humidity}</p>
                    <p>Pressure: {meal.pressure}</p>
                    </div>
                      : <div>N/A</div>}
                    
                  </div>
                </div>
              </div>
              </div>
              :
                      <div>
                         <div className="meal-card empty">
                          <div className="meal-text empty">Getting your meal...</div>
                        </div>
                      </div>
                }
        </div>
        </div>
      </div>
      </div>
    );
  }
}

const mapStateToProps = state => ({
  meals: state.mealsReducer.meals,
  singleMeal: state.mealsReducer.meal,
  user: state.userReducer.user
});

export default connect(
  mapStateToProps,
  { getMeal, changeMeal }
)(withRouter(SingleMeal));
