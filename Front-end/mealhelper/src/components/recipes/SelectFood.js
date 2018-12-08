import React, { Component } from "react";
import { connect } from "react-redux";
//change the route for this
import { addUser } from "../../store/actions/userActions";
import { withRouter, Link, Route } from "react-router-dom";
import Nutrients from "./Nutrients";
// import { Alert } from "reactstrap";
import axios from "axios";
import Recipe from "./recipe";
import SelectedFoods from "./SelectedFoods";
import FoodSearch from "./FoodSearch";
import "./recipes.css";

class SelectFood extends Component {
  constructor(props) {
    super(props);
    this.state = {
      selectedFoods: [],
      ndbno_id: []
    };
  }
  componentWillReceiveProps(nextProps) {
    this.setState({ selectedFoods: nextProps.foods });
  }

  sum = (foods, prop) => {
    return foods
      .reduce((memo, food) => parseInt(food[prop], 10) + memo, 0.0)
      .toFixed(2);
  };

  render(props) {
    console.log(this.props);
    const { foods } = this.props;
    const foodRows = foods.map((food, idx) => (
      <tr
        food={food}
        key={food.offset}
        name={food.name}
        //   kcal={food.nutrients[0].value}
        //   protein_g={food.nutrients[1].value}
        //   fat_g={food.nutrients[2].value}
        //   carbohydrate_g={food.nutrients[3].value}
        onClick={() => this.props.onFoodClick(idx)}
      >
        <td>{food.name}</td>
      </tr>
    ));
    return (
      <div>
        <table className="ui selectable structured large table">
          <thead>
            <tr>
              <th colSpan="5">
                <h3>Selected foods</h3>
              </th>
            </tr>
            <tr>
              <th className="eight wide">Selected Food</th>
            </tr>
          </thead>
          <tbody>{foodRows}</tbody>
        </table>
        <div>
          <Nutrients
            name={this.props.name}
            calories={this.props.calories}
            servings={this.props.servings}
            logoutModal={this.props.logoutModal}
            logoutMethod={this.props.logoutMethod}
            setCalories={this.props.setCalories}
            onFoodClick={this.props.onFoodClick}
            selectedFoods={this.state.selectedFoods}
          />
        </div>
      </div>
    );
  }
}

const mapStateToProps = state => ({
  user: state.user
});

export default connect(
  mapStateToProps,
  { addUser }
)(withRouter(SelectFood));
