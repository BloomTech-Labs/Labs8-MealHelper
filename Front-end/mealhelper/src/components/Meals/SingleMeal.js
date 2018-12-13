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

class SingleMeal extends Component {
  constructor(props) {
    super(props);
    this.state = {
      currentMeal: {
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
      }
    }
  }

  componentDidMount() {
    const { mealID } = this.props.match.params;
    
  }

  componentDidUpdate(prevProps) {

  }

  render() {
    const meal = this.state.currentMeal;
    return(
      <div className="single-meal-full-width">
        <div className="single-meal-container">
          <div className="single-meal-bg">
            <div className="single-meal-content">
              <div className="single-meal-heading">
                <h1>{meal.name}</h1>
                <p>{meal.date}</p>
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