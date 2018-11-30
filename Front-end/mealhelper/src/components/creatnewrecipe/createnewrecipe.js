import React, { Component } from "react";
import { connect } from "react-redux";
//change the route for this
import { addRecipe, getRecipe } from "../../store/actions/recipeActions.js";
import { withRouter, Link } from "react-router-dom";
// import { Alert } from "reactstrap";
// import axios from "axios";
// import Recipe from "../recipes/recipe";
import SelectedFoods from "../recipes/SelectFood";
import FoodSearch from "../recipes/FoodSearch";
import {
  Button,
  Modal,
  ModalHeader,
  ModalBody
  // ModalFooter,
  // UncontrolledDropdown,
  // DropdownToggle,
  // DropdownMenu,
  // DropdownItem
} from "reactstrap";
import "../recipes/recipes.css";

class CreateNewRecipe extends Component {
  constructor(props) {
    super(props);

    this.state = {
      list: [],
      selectedFoods: [],
      ingredients: [],
      search: "",
      name: "",
      calories: 0,
      serving: 1,
      ndbno: null,
      modal: false,
      modalLogout: false
    };
  }

  toggle = () => {
    this.setState({
      modal: !this.state.modal
    });
  };
  componentDidMount() {
    if (localStorage.getItem("token")) {
      const id = this.props.user.userID;
      this.props.getRecipe(id);
    } else {
      this.props.history.push("/");
    }
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

  handleSubmit = event => {
    event.preventDefault();
    const user_id = this.props.user.userID;
    const ingredient_id = this.state.ingredients.id;
    const { name, calories, servings } = this.state;
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
    this.setState({
      ingredients: ingredient
    });
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

  saveCalories = caloriesTotal => {
    this.setState({ calories: caloriesTotal });
  };
  toggleLogout = () => {
    this.setState({
      modalLogout: !this.state.modalLogout
    });
  };
  logout = event => {
    event.preventDefault();
    localStorage.removeItem("token");
    this.props.history.push("/");
  };
  render() {
    const { selectedFoods } = this.state;
    return (
      <div>
        <div className="home-container">
          <div className="sidebar">
            <Link to="/homepage" style={{ textDecoration: "none" }}>
              <h2 className="titlelinks">Home</h2>
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
            <Button color="danger" onClick={this.toggleLogout}>
              Log Out
            </Button>
          </div>
          <div>
            <Button color="success" onClick={this.toggle}>
              + New Recipe
            </Button>
            <Modal
              isOpen={this.state.modal}
              toggle={this.toggle}
              className={this.props.className}
            >
              <ModalHeader toggle={this.toggle}>New Recipe</ModalHeader>
              <ModalBody>
                <p>Details</p>
                <hr />
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
                  <br />
                  <br />
                  <p>Servings:</p>
                  <input
                    id="name"
                    className="name-recipe"
                    type="number"
                    name="name"
                    onChange={this.handleChange}
                    value={this.state.serving}
                    placeholder="Servings"
                  />

                  <br />
                  <p>Total Calories: {this.state.calories}</p>
                  <br />
                  <div className="dynamic-display">
                    <FoodSearch onFoodClick={this.addFood} />
                    <SelectedFoods
                      logoutModal={this.state.modal}
                      logoutMethod={this.toggle}
                      name={this.state.name}
                      calories={this.state.calories}
                      servings={this.state.serving}
                      setCalories={this.saveCalories}
                      foods={selectedFoods}
                      onFoodClick={this.removeFoodItem}
                    />
                  </div>
                </form>
              </ModalBody>
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
          <Modal
            isOpen={this.state.modalLogout}
            toggle={this.toggleLogout}
            className={this.props.className}
          >
            <ModalHeader toggle={this.toggleLogout}>
              Do you wish to log out?
            </ModalHeader>
            <Button onClick={this.logout} color="danger">
              Log out
            </Button>
            <Button onClick={this.toggleLogout} color="primary">
              Cancel
            </Button>
          </Modal>
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
