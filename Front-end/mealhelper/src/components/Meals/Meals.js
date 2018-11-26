import React, { Component } from "react";
import { connect } from "react-redux";
//change the route for this
import { addWeatherByUser } from "../../store/actions/weatherActions";
import { withRouter, Link, Route } from "react-router-dom";
// import { Alert } from "reactstrap";
import Recipes from "../recipes/recipes";
import axios from "axios";
import "./weather.css";

class Weather extends Component {
	constructor(props) {
		super(props);

		this.state = {
			city: "",
			zip: "",

			name: "",
			temp: null,
			humidity: null,
			pressure: null
		};
	}
	///converted to Imperial measurement

	saveWeather = event => {
		event.preventDefault();
		const user_id = this.props.user.userID;
		const { name, humidity, pressure, temp } = this.state;
		const weather = { name, humidity, pressure, temp, user_id };
		console.log(weather);
		this.props.addWeatherByUser(weather);
		this.props.history.push("/homepage");
	};

	handleChange = event => {
		event.preventDefault();
		this.setState({
			[event.target.name]: event.target.value
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
)(withRouter(Weather));
