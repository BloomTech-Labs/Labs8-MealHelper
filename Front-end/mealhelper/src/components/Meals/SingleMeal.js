// == Dependencies == //
import React, { Component } from "react";
import { connect } from "react-redux";
import { withRouter } from "react-router-dom";
// == Actions == //
import { 
  getMeal,
  changeMeal
} from "../../store/actions/mealActions";
// == Styles == //
import "./singlemeal.css"

class SingleMeal extends Component {
  constructor(props) {
    super(props);
    this.state = {
      meal: {
        id: 1,
        user_id: 1,
        mealTime: "Breakfast",
        experience: "",
        name: "Basic Morning Breakfast",
        temp: null,
        humidity: null,
        pressure: null,
        notes: "a delicious meal",
        date: "01/01/2018",
        servings: 1,
        recipe_id: 1
      }
    }
  }

  componentDidMount() {
    const { mealID } = this.props.match.params;
  }

  componentDidUpdate(prevProps) {

  }

  render() {
    const meal = this.state.meal;
    return(
      <div className="single-meal-full-width">
        <div className="single-meal-container">
          <div className="single-meal-bg">
            <div className="single-meal-content">
              <div className="single-meal-heading">
              <div className="sm-top"><h1>{meal.name}</h1></div>  
              <div className="sm-bottom"><h3>{meal.date}</h3>
                    <div className="sm-exp-buttons">
                    <button 
                      className={meal.experience === "good" ? "mealbook-btn-active" : "mealbook-btn-inactive"} 
                      onClick={() => this.setState(prevState => ({ 
                        meal: {
                          ...prevState.meal,
                          experience: "good"
                        }
                      }))}>
                      👍
                    </button>
                    <button 
                      className={meal.experience === "bad" ? "mealbook-btn-active" : "mealbook-btn-inactive"} 
                      onClick={() => this.setState(prevState => ({ 
                        meal: {
                          ...prevState.meal,
                          experience: "bad"
                        }
                      }))}>
                      👎 
                    </button>
                    </div>
                </div>  
              </div>
              <div className="single-meal-details">
              <div className="sm-details-top">
                <p>Recipe Name</p>
                <p>{meal.servings} {meal.servings.length > 1 ? "servings" : "serving"}</p>
              </div>
              <div className="sm-details-middle">
              
              </div>
              <div className="sm-details-bottom">
              
              </div>
              <p>{meal.mealTime}</p>
              <p>Recipe:</p>
              <p>Servings: {meal.servings}</p>
              
              <p>Calories: 0000</p>
              <p>Protein: 000</p>
              <p>Carbs: 000</p>
              <p>Fat: 000</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    )
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