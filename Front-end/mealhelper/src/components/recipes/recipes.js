import React, { Component } from "react";
import { connect } from "react-redux";
//change the route for this
import { addUser } from "../../store/actions/userActions";
import { withRouter, Link, Route } from "react-router-dom";
// import { Alert } from "reactstrap";
import axios from "axios";
import Recipe from "./recipe";
import SelectedFoods from "./SelectedFoods";
import FoodSearch from "./FoodSearch";
import "./recipes.css";

class Recipes extends Component {
	state = {
		selectedFoods: []
	};

	removeFoodItem = itemIndex => {
		const filteredFoods = this.state.selectedFoods.filter(
			(item, idx) => itemIndex !== idx
		);
		this.setState({ selectedFoods: filteredFoods });
	};

	addFood = food => {
		const newFoods = this.state.selectedFoods.concat(food);
		this.setState({ selectedFoods: newFoods });
	};

	render() {
		const { selectedFoods } = this.state;

		return (
			<div className="App">
				<div className="sidebar">
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
				</div>
				<div className="ui text container">
					<SelectedFoods
						foods={selectedFoods}
						onFoodClick={this.removeFoodItem}
					/>
					<FoodSearch onFoodClick={this.addFood} />
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
)(withRouter(Recipes));
