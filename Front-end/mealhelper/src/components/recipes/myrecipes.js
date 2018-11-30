import React, { Component } from "react";
import { connect } from "react-redux";
//change the route for this
import { getMeals } from "../../store/actions/mealActions.js";
import { withRouter, Link } from "react-router-dom";
// import { Alert } from "reactstrap";
// import axios from "axios";
import Recipe from "./recipe";
import "./recipes.css";
import SideBar from "../sidebar/sidebar";

class MyRecipes extends Component {
  constructor(props) {
    super(props);

    this.state = {
      list: [],
      search: "",
      name: "",
      ndbno: null
    };
  }
  componentDidMount() {
    if (localStorage.getItem("token")) {
      const id = this.props.user.userID;
      this.props.getMeals(id);
    } else {
      this.props.history.push("/");
    }
  }
  componentWillReceiveProps(nextProps) {
    this.setState({ list: nextProps.meals });
  }

  settingState() {
    this.setState({ list: this.props.meals });
  }

  handleChange = event => {
    event.preventDefault();
    this.setState({
      [event.target.name]: event.target.value
    });
  };

  render() {
    return (
      <div className="weather-container">
        <div className="home-container">
          {/* <div className="sidebar">
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
          </div> */}
          <SideBar />
          <div className="dynamic-display">
            {this.state.list.map(item => (
              <Recipe
                item={item}
                key={item.ndbno}
                name={item.name}
                ndbno={item.ndbno}
              />
            ))}
          </div>
        </div>
      </div>
    );
  }
}

const mapStateToProps = state => {
  console.log(state);
  return {
    user: state.userReducer.user,
    meals: state.mealsReducer.meals
  };
};

export default connect(
  mapStateToProps,
  { getMeals }
)(withRouter(MyRecipes));
