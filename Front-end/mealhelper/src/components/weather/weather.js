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

	getWeatherCity = event => {
		event.preventDefault();
		const city = this.state.city.toLowerCase().trim();
		console.log(city);
		axios
			.get(
				`https://api.openweathermap.org/data/2.5/find?q=${city}&units=imperial&appid=46454cdfa908cad35b14a05756470e5c`
			)
			.then(response => {
				this.setState({
					name: response.data.list[0].name,
					temp: response.data.list[0].main.temp,
					humidity: response.data.list[0].main.humidity,
					pressure: response.data.list[0].main.pressure
				});
				console.log(this.state);
				console.log(response.data.list[0]); //returns JSON correctly
				console.log(this.state.weather.main.temp); //returns correct value in imperial
			})
			.catch(error => {
				console.log("Error", error);
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
				<div className="weather-container">
					<form>
						Search by City:
						<input
							className="city-search"
							type="text-title"
							name="city"
							value={this.state.city}
							onChange={this.handleChange}
							placeholder="Search by City. . ."
						/>
						Search by Zip:
						<input
							className="zip-search"
							type="text-title"
							name="zip"
							value={this.state.zip}
							onChange={this.handleChange}
							placeholder="Search by Zip. . ."
						/>
						<button onClick={this.getWeatherCity}>Search By City</button>
						<button onClick={this.getWeatherZip}>Search By Zip</button>
					</form>
					<div className="dynamic-display">City: {this.state.city}</div>
					<div className="dynamic-display">Temp: {this.state.temp}</div>
					<button onClick={this.saveWeather}>Save Weather</button>

					<Link
						to="/homepage/weather/myweather"
						style={{ textDecoration: "none" }}
					>
						<h2 className="titlelinks">View My Saved Weather Reports</h2>
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
