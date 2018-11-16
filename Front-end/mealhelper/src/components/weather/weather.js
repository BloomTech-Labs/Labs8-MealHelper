import React, { Component } from "react";
import { connect } from "react-redux";
//change the route for this
import { addUser } from "../../store/actions/userActions";
import { withRouter, Link, Route } from "react-router-dom";
// import { Alert } from "reactstrap";
import axios from "axios";
import "./weather.css";

class Weather extends Component {
	constructor(props) {
		super(props);

		this.state = {
			weather: {
				name: "",
				description: "",
				main: { temp: null },
				humidity: null,
				pressure: null
			}
		};
	}
	///converted to Imperial measurement
	componentDidMount() {
		axios
			.get(
				`https://api.openweathermap.org/data/2.5/find?q=Seattle&units=imperial&appid=46454cdfa908cad35b14a05756470e5c`
			)
			.then(response => {
				this.setState({
					weather: response.data.list[0]
				});
				console.log(response.data.list[0]); //returns JSON correctly
				console.log(this.state.weather.main.temp); //returns correct value in imperial
			})
			.catch(error => {
				console.log("Error", error);
			});
	}

	handleChange = event => {
		event.preventDefault();
		this.setState({
			[event.target.name]: event.target.value
		});
	};

	createUser = event => {
		event.preventDefault();
		if (!this.state.email || !this.state.password) {
			this.setState({ visable: true });
		} else {
			const { email, password, zip, healthCondition } = this.state;
			const user = { email, password, zip, healthCondition };
			this.props.addUser(user);
			// this.props.history.push("/");
		}
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
					<div className="weather-card">
						<h1>City: {this.state.weather.name}</h1>
						<hr />
						<h1>Temp:{this.state.weather.main.temp}</h1>
					</div>

					<div className="dynamic-display" />
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
)(withRouter(Weather));
