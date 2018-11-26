import React, { Component } from "react";
import { connect } from "react-redux";
import {
	Button,
	Modal,
	ModalHeader,
	ModalBody,
	ModalFooter,
	UncontrolledDropdown,
	DropdownToggle,
	DropdownMenu,
	DropdownItem
} from "reactstrap";
//change the route for this
import { addMeal } from "../../store/actions/mealActions";
import { withRouter, Link, Route } from "react-router-dom";
// import { Alert } from "reactstrap";
import Recipes from "../recipes/recipes";
import axios from "axios";

class Meals extends Component {
	constructor(props) {
		super(props);

		this.state = {
			modal: false,
			dropdownOpen: false,
			recipes: [
				{
					id: 1,
					name: "Pepperoni Pizza Slice",
					calories: 250,
					servings: 1,
					meal_id: 3,
					user_id: 1
				},
				{
					id: 2,
					name: "Mac and Cheese",
					calories: 300,
					servings: 2,
					meal_id: 2,
					user_id: 2
				},
				{
					id: 3,
					name: "Ham and Cheese Sandwhich",
					calories: 175,
					servings: 4,
					meal_id: 1,
					user_id: 3
				}
			],
			zip: "",
			meals: [],
			recipe: [],
			mealTime: "",
			experience: [],
			date: "",
			notes: "",
			servings: "",

			name: "",
			temp: null,
			humidity: null,
			pressure: null
		};
		this.toggle = this.toggle.bind(this);
	}
	///converted to Imperial measurement
	componentDidMount(props) {
		console.log(this.props.user.zip);
		this.setState({ zip: this.props.user.zip });
	}
	// componentWillReceiveProps(prevState){

	// }
	toggle() {
		this.setState({
			modal: !this.state.modal
		});
	}
	toggleDropDown() {
		this.setState(prevState => ({
			dropdownOpen: !prevState.dropdownOpen
		}));
	}
	chooseMeal(meal) {
		console.log(meal);
		this.setState({ mealTime: meal });
	}
	chooseExperience(mood) {
		console.log(mood);
		this.setState({ experience: mood });
	}
	saveMeal = event => {
		event.preventDefault();
		const user_id = this.props.user.userID;
		const {
			mealTime,
			experience,
			date,
			notes,
			name,
			temp,
			humidity,
			pressure,
			recipe,
			servings
		} = this.state;
		const meal = {
			user_id,
			mealTime,
			experience,
			date,
			notes,
			name,
			temp,
			humidity,
			pressure,
			recipe,
			servings
		};
		this.props.addMeal(meal);
	};
	chooseRecipe = recipe => {
		console.log(recipe);
		this.setState({ recipe: recipe });
	};
	handleChange = event => {
		event.preventDefault();
		this.setState({
			[event.target.name]: event.target.value
		});
	};
	getWeatherZip = event => {
		event.preventDefault();
		const zip = `${this.state.zip}`;
		console.log(zip);
		axios
			.get(
				`https://api.openweathermap.org/data/2.5/weather?zip=${zip},us&appid=46454cdfa908cad35b14a05756470e5c`
			)
			.then(response => {
				console.log(response);
				this.setState({
					name: response.data.name,
					temp: response.data.main.temp,
					humidity: response.data.main.humidity,
					pressure: response.data.main.pressure
				});
			})
			.catch(error => {
				console.log("Error", error);
			});
	};

	render() {
		return (
			<div className="home-container">
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
				<div>
					<Button color="success" onClick={this.toggle}>
						+ New Meal
					</Button>
					<Modal
						isOpen={this.state.modal}
						toggle={this.toggle}
						className={this.props.className}
					>
						<ModalHeader toggle={this.toggle}>New Meal</ModalHeader>
						<ModalBody>
							<p>Date:</p>
							<form>
								<input
									id="date"
									className="date-meal"
									type="date"
									name="date"
									onChange={this.handleChange}
									value={this.state.date}
									placeholder=" / /"
								/>
							</form>
						</ModalBody>
						<ModalBody>Recipe: {this.state.recipe.name}</ModalBody>
						<UncontrolledDropdown>
							<DropdownToggle caret>Dropdown</DropdownToggle>
							<DropdownMenu>
								{this.state.recipes.map(recipe => (
									<DropdownItem
										recipe={recipe}
										name={recipe.name}
										onClick={() => this.chooseRecipe(recipe)}
									>
										{recipe.name}
									</DropdownItem>
								))}
							</DropdownMenu>
						</UncontrolledDropdown>
						<ModalBody>Which meal was this? {this.state.mealTime}</ModalBody>
						<UncontrolledDropdown>
							<DropdownToggle caret>Dropdown</DropdownToggle>
							<DropdownMenu>
								<DropdownItem onClick={() => this.chooseMeal("Breakfast")}>
									Breakfast
								</DropdownItem>
								<DropdownItem onClick={() => this.chooseMeal("Lunch")}>
									Lunch
								</DropdownItem>
								<DropdownItem onClick={() => this.chooseMeal("Dinner")}>
									Dinner
								</DropdownItem>
								<DropdownItem onClick={() => this.chooseMeal("Snack")}>
									Snack
								</DropdownItem>
							</DropdownMenu>
						</UncontrolledDropdown>
						<ModalBody>
							How was the experience? {this.state.experience}
						</ModalBody>
						<UncontrolledDropdown>
							<DropdownToggle caret>Dropdown</DropdownToggle>
							<DropdownMenu>
								<DropdownItem onClick={() => this.chooseExperience("😁")}>
									😁
								</DropdownItem>
								<DropdownItem onClick={() => this.chooseExperience("😐")}>
									😐
								</DropdownItem>
								<DropdownItem onClick={() => this.chooseExperience("😰")}>
									😰
								</DropdownItem>
								<DropdownItem onClick={() => this.chooseExperience("🤢")}>
									🤢
								</DropdownItem>
							</DropdownMenu>
						</UncontrolledDropdown>
						<ModalBody>
							<p>Notes:</p>
							<form>
								<input
									id="notes"
									className="notes-meal"
									type="text"
									name="notes"
									onChange={this.handleChange}
									value={this.state.notes}
									placeholder="Notes. . ."
								/>
							</form>
						</ModalBody>
						<ModalBody>
							<p>Weather:</p>
							<p>City: {this.state.name},</p>
							<p>Temp: {this.state.temp} °F</p>
							<p>Humidity: {this.state.humidity}</p>
							<p>Pressure: {this.state.pressure}</p>
							<button onClick={this.getWeatherZip}>Get Weather</button>
						</ModalBody>
						<ModalFooter>
							<Button color="success" onClick={this.saveMeal}>
								Save Meal
							</Button>{" "}
							<Button color="secondary" onClick={this.toggle}>
								Cancel
							</Button>
						</ModalFooter>
					</Modal>
				</div>
				<div className="mealList-Display">
					{/* {this.state.meals.map(meal => (
						<OneMeal
							meal={meal}
							mealTime={meal.mealTime}
							experience={meal.experience}
							date={meal.date}
						/>
					))} */}
				</div>
			</div>
		);
	}
}

const mapStateToProps = state => ({
	user: state.userReducer.user,
	meals: state.mealsReducer.meals
});

export default connect(
	mapStateToProps,
	{ addMeal }
)(withRouter(Meals));
