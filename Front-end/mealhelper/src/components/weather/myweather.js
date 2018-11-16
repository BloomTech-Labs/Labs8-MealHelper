import React, { Component } from "react";
import { connect } from "react-redux";
//change the route for this
import { getWeatherByUserID } from "../../store/actions/weatherActions";
import { withRouter, Link, Route } from "react-router-dom";
// import { Alert } from "reactstrap";
import axios from "axios";
import "./weather.css";

class Weather extends Component {
	constructor(props) {
		super(props);

		this.state = {
			name: "",
			description: "",
			main: { temp: null },
			humidity: null,
			pressure: null
		};
	}
	///converted to Imperial measurement
	componentDidMount() {
		console.log("im in component did mount");
		this.getWeather();
		console.log(this.state);
	}

	componentWillReceiveProps(nextProps) {
		console.log("im in component did recieve props");
		console.log(nextProps);
	}

	getWeather = event => {
		event.preventDefault();
		const user_id = this.props.user.userID;
		const { name, description, main, humidity, pressure } = this.state.weather;
		const weather = { name, description, main, humidity, pressure, user_id };
		this.props.getWeatherByUserID(weather);
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
				<div className="weather-container">
					Name: {this.state.name}
					Temp: {this.state.main.temp}
					Humidity: {this.state.humidity}
					Pressure: {this.state.pressure}
				</div>
			</div>
		);
	}
}

const mapStateToProps = state => ({
	user: state.user,
	weather: state.weatherReducer
});

export default connect(
	mapStateToProps,
	{ getWeatherByUserID }
)(withRouter(Weather));
