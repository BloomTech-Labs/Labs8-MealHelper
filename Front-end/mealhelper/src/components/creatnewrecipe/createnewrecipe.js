import React, { Component } from "react";
import { connect } from "react-redux";
//change the route for this
import { addRecipe, getRecipe } from "../../store/actions/recipeActions.js";
import { withRouter, Link, Route } from "react-router-dom";
// import { Alert } from "reactstrap";
import axios from "axios";
import Recipe from "../recipes/recipe";
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
import "../recipes/recipes.css";

class CreateNewRecipe extends Component {
	constructor(props) {
		super(props);

		this.state = {
            list: [],
            ingredients: [],
			search: "",
            name: "",
            calories:"",
            serving:"",
            ndbno: null,
            modal: false
        };
    }

    searchIngredients = event => {
		event.preventDefault();
		axios
			.get(
				`https://api.nal.usda.gov/ndb/search/?format=json&q=${
					this.state.search
				}&sort=n&max=25&offset=0&api_key=c24xU3JZJhbrgnquXUNlyAGXcysBibSmESbE3Nl6`
			)
			.then(response => {
				console.log(response);
				this.setState({
					list: response.data.list.item
				});
			})
			.catch(error => {
				console.log("Error", error);
			});
	};
    
    toggle = () => {
        this.setState({
            modal: !this.state.modal
        });
    }
	componentDidMount() {

		const id = this.props.user.userID;
		this.props.getRecipe(id);
	}
	componentWillReceiveProps(nextProps) {
		this.setState({ list: nextProps.recipes });
	}

	settingState() {
		this.setState({ list: this.props.recipes });
	}

	handleChange = event => {
		event.preventDefault();
		this.setState({
			[event.target.name]: event.target.value
		});
    };
    
    handleSubmit = event  => {
		event.preventDefault();
        const user_id = this.props.user.userID;
        const ingredient_id = this.state.ingredients.id;
		const {
            name,
            calories,
            servings
		} = this.state;
		const recipe = {
            user_id,
            ingredient_id,
            name,
            calories,
            servings
		};
		this.props.addRecipe(recipe);
    };
    
    saveItem = (item, event) => {
        console.log(event);
        event.preventDefault();
        const { manu, ndbno } = item;
        const ingredient = { manu, ndbno };
        this.setState ({
            ingredients: ingredient
        });
    }


	render() {
		return (
			<div className="weather-container">
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
						+ New Recipe
					</Button>
					<Modal
						isOpen={this.state.modal}
						toggle={this.toggle}
						className={this.props.className}>
						<ModalHeader toggle={this.toggle}>New Recipe</ModalHeader>
						<ModalBody>
							<p>Details</p>
                            <hr/>
							<form onSubmit={this.handleSubmit}>
                            <p>Recipe Name:</p>
								<input
									id="name"
									className="name-recipe"
									type="text"
									name="name"
									onChange={this.handleChange}
									value={this.state.name}
									placeholder="Recipe Name"
								/>
                            <br/>
                            <p>Recipe Calories:</p>
							    <input
								    id="calories"
								    className="calories-recipe"
								    type="text"
								    name="calories"
								    onChange={this.handleChange}
								    value={this.state.calories}
								    placeholder="Calories"
							/>
                            <br/>
                            <p>Recipe Ingredients: {this.state.ingredients}</p>
							<input
								className="food-search"
								type="text"
                                name="search"
                                onChange={this.handleChange}
								value={this.state.search}
								placeholder="Search Ingredients. . ."
								required
							/>
                            <br/>
							<button onClick={this.searchIngredients}>Search</button>
                            <button onClick={this.addIngredients}>Add</button>
						<div className="dynamic-display">
						{this.state.list.map(item => (
							<button
                                onClick={() => this.saveItem(item)}
								item={item}
								key={item.ndbno}
								name={item.name}
								ndbno={item.ndbno}
							> {item.name}</button>
						))}
						<Link
							to="/homepage/ingredients/myingredients"
							style={{ textDecoration: "none" }}
						>
							<h2 className="titlelinksrecipe">View my saved ingredients</h2>
						</Link>
					</div>
							</form>
						</ModalBody>
						<ModalFooter>
							<Button color="success" onClick={this.saveMeal}>
								Save Recipe
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
			
			</div>
		);
	}
}

const mapStateToProps = state => {
	return {
		user: state.userReducer.user,
		recipe: state.recipesReducer.recipe
	};
};

export default connect(
	mapStateToProps,
	{ addRecipe, getRecipe }
)(withRouter(CreateNewRecipe));







