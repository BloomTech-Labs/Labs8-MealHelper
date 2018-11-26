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
import { addWeatherByUser } from "../../store/actions/weatherActions";
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
			experience: "",
			date: "",

			city: "",
			name: "",
			temp: null,
			humidity: null,
			pressure: null
		};
		this.toggle = this.toggle.bind(this);
	}
	///converted to Imperial measurement
	componentDidMount(props) {
		console.log(this.props.user[0].zip);
		this.setState({ zip: this.props.user[0].zip });
	}
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
		const { name, humidity, pressure, temp } = this.state;
		const weather = { name, humidity, pressure, temp, user_id };
		console.log(weather);
		this.props.addWeatherByUser(weather);
		this.props.history.push("/homepage");
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
		const zip = this.state.zip.trim();
		console.log(zip);
		axios
			.get(
				`http://api.openweathermap.org/data/2.5/weather?zip=${zip},us&appid=46454cdfa908cad35b14a05756470e5c`
			)
			.then(response => {
				this.setState({
					name: response.data.list[0].name,
					temp: response.data.list[0].main.temp,
					humidity: response.data.list[0].main.humidity,
					pressure: response.data.list[0].main.pressure
				});
				console.log(response.data.list[0]); //returns JSON correctly
				console.log(this.state.weather.main.temp); //returns correct value in imperial
			})
			.catch(error => {
				console.log("Error", error);
			});
	};

	render() {
		return (
			<div className="home-container">
				<div className="sidebar">
					<Link to="/homepage/weather" style={{ textDecoration: "none" }}>
						<h2 className="titlelinks">Weather</h2>
					</Link>
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
							<textarea> </textarea>
						</ModalBody>
						<ModalBody>
							<p>Weather:</p>
							<button>Get Weather</button>
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
	user: state.userReducer.user
});

export default connect(
	mapStateToProps,
	{ addWeatherByUser }
)(withRouter(Meals));
