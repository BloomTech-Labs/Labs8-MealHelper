// == Dependencies == //
import React, { Component } from "react";
import { connect } from "react-redux";
import { withRouter } from "react-router-dom";
import axios from "axios";
// == Actions == //
import { getMeal, changeMeal, deleteMeal } from "../../store/actions/mealActions";
// == Styles == //
import "./singlemeal.css";
import { Button, Modal, ModalHeader, ModalBody } from "reactstrap";

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
      mealToUpdate: {},
      modal: false,
      notes: "",
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
    if (JSON.stringify(this.props.meals) !== JSON.stringify(prevProps.meals)) {
      this.props.getMeal(mealID, userID);
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
    return Math.round(calTotal);
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
    return Math.round(proTotal);
  }

  carbs() {
    //pull all objects where nutrient === Carbohydrate, by difference
    //return obbj.value
    let carbs = this.state.nutrition.filter(nutr => nutr.nutrient === "Carbohydrate, by difference");
    let carbTotal = carbs.reduce((cal, nutrient) => {
      return cal += Number(nutrient.value)
    }, 0);
    console.log("carbTotal", carbTotal);
    return Math.round(carbTotal);
  }

  fat() {
//pull all objects where nutrient === Total lipid (fat)
    //return obj.value
    let fat = this.state.nutrition.filter(nutr => nutr.nutrient === "Total lipid (fat)");
    let fatTotal = fat.reduce((cal, nutrient) => {
      return cal += Number(nutrient.value)
    }, 0);
    console.log("fatTotal", fatTotal);
    return Math.round(fatTotal);
  }


  toggle = () => {
    this.setState({
      modal: !this.state.modal
    });
  };

  sendToEdit(noteChange) {
    this.toggle();
    const notes = noteChange;
    const mealBody = { ...this.props.singleMeal, notes };
    console.log("mealBody", mealBody)
   this.props.changeMeal(mealBody);
  }

  editExperience(experience) {
    const mealBody = { ...this.props.singleMeal, experience };
    console.log("mealBody experience", mealBody)
    this.props.changeMeal(mealBody);
  }

  showModal = () => {
    this.toggle();
    const mealToUpdate = this.state.meal;
    this.setState({
      mealToUpdate
    })
  };

  deletePush(mealID, userID) {
    this.props.deleteMeal(mealID, userID);
    this.props.history.push("/homepage/meals/mealbook");
  }

  handleChange = event => {
    event.preventDefault();
    this.setState({
      [event.target.name]: event.target.value
    });
  };

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
                        meal.experience === "0"
                          ? "mealbook-btn-active"
                          : "mealbook-btn-inactive"
                      }
                      onClick={() =>
                        this.editExperience("0")
                      }
                    >
                      👍
                    </button>
                    <button
                      className={
                        meal.experience === "1"
                          ? "mealbook-btn-active"
                          : "mealbook-btn-inactive"
                      }
                      onClick={() => this.editExperience("1")
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
                    <p>{meal.notes}</p>
                    <button className="sm-edit-btn" onClick={() => this.showModal()}>Edit</button>
                  </div>
                  <div className="sm-weather">
                  
                    <h3>Weather</h3>
                    {meal.temp ? 
                    <div>
                      <table className="sm-weather-table">
                        <tr>
                          <td className="sm-td-left">Temp</td>
                          <td className="sm-td-right">{meal.temp}</td>
                        </tr>
                        <tr>
                          <td className="sm-td-left">Humidity</td>
                          <td className="sm-td-right">{meal.humidity}</td>
                        </tr>
                        <tr>
                          <td className="sm-td-left">Pressure</td>
                          <td className="sm-td-right">{meal.pressure}</td>
                        </tr>
                      </table>
                    {/* <p>Temp: {meal.temp}</p>
                    <p>Humidity: {meal.humidity}</p>
                    <p>Pressure: {meal.pressure}</p> */}
                    </div>
                      : <div>N/A</div>}
                    
                  </div>
                </div>
              </div>
              </div>
              :
                      <div>
                         <div className="meal-card-empty">
                          <div className="meal-text-empty">Getting your meal...</div>
                        </div>
                      </div>
                }
        </div>
        </div>
      </div>
      <div className="delete-sm">
      <button className="delete-sm-btn" onClick={() => this.deletePush(meal.id, meal.user_id)}>Delete</button>
      </div>
      <Modal
          isOpen={this.state.modal}
          toggle={this.toggle}
          >
            <ModalHeader
              toggle={this.toggle}>Edit Meal</ModalHeader>
           <ModalBody>
             <p>Notes:</p>
             <textarea 
              id="notes"
              name="notes"
              type="label"
              value={this.state.notes}
              placeholder={this.state.notes}
              onChange={this.handleChange}
             />              
             <Button color="info" onClick={() => this.sendToEdit(this.state.notes)}>
                Submit
              </Button>
           </ModalBody>
         </Modal>
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
  { getMeal, changeMeal, deleteMeal }
)(withRouter(SingleMeal));
