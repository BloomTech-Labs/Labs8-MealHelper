import React, { Component } from "react";
import { connect } from "react-redux";
//change the route for this
import { addUser } from "../../store/actions/userActions";
import { withRouter, Link, Route } from "react-router-dom";
// import { Alert } from "reactstrap";
import axios from "axios";
import "./recipes.css";

class Recipe extends Component {
	constructor(props) {
		super(props);

		this.state = {
			nutrients: []
		};
	}
	///converted to Imperial measurement
	componentDidMount() {
		axios
			.get(
				`https://api.nal.usda.gov/ndb/nutrients/?format=json&api_key=c24xU3JZJhbrgnquXUNlyAGXcysBibSmESbE3Nl6&nutrients=205&nutrients=204&nutrients=208&nutrients=269&ndbno=01008`
			)
			.then(response => {
				this.setState({
					nutrients: response.data.report.foods[0].name
				});
				console.log(response.data.report.foods[0].name); //returns JSON correctly
				console.log(this.state.nutrients); //returns correct value (304.15)
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
			<div className="weather-container">
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

					<div className="recipe-card">
						<h1>{this.state.nutrients}</h1>
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
)(withRouter(Recipe));
