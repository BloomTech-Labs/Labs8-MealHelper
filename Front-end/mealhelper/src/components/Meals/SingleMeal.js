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
      recipe: [],
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
    // axios
    //   .get(
    //     `https://labs8-meal-helper.herokuapp.com/recipe/single/${this.props.singleMeal.recipe_id}`
    //   )
    //   .then(response => {
    //     this.setState({ recipe: response.data });
    //     const recipe_id = this.state.recipe.id;

    //     axios
    //       .get(
    //         `https://labs8-meal-helper.herokuapp.com/ingredients/recipe/${recipe_id}`
    //       )
    //       .then(response => {
    //         this.setState({ ingredients: response.data });
    //         axios
    //           .get(
    //             `https://labs8-meal-helper.herokuapp.com/nutrients/${recipe_id}`
    //           )
    //           .then(response => {
    //             this.setState({ nutrition: response.data })
    //           });
    //       });
    //   });
  }

  componentDidUpdate(prevProps) {
    let userID = this.props.user.id;
    let { mealID } = this.props.match.params;
    if (JSON.stringify(this.props.singleMeal) !== JSON.stringify(prevProps.singleMeal)) {
      this.props.getMeal(mealID, userID);
    }
  }

  render() {
    const meal = this.props.singleMeal;
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
                  <p className="sm-recipe-name">Recipe Name</p>
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
                      <td>0000</td>
                      <td>0000</td>
                      <td>0000</td>
                      <td>0000</td>
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
