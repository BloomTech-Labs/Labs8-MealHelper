import React, { Component } from "react";
import { connect } from "react-redux";
import "./homepage.css";
//change the route for this
import { addUser } from "../../store/actions/userActions";
import { withRouter } from "react-router-dom";
import { Alert } from "reactstrap";

class HomePage extends Component {
	constructor(props) {
		super(props);

		this.state = {
			email: "",
			password: "",
			zip: null,
			healthCondition: "",
			visable: false
		};
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
                    <h2 className="titlelinks">Weather</h2>
                    <h2 className="titlelinks">Recipes</h2>
                    <h2 className="titlelinks">Alarms</h2>
                    <h2 className="titlelinks">Meals</h2>
                    <h2 className="titlelinks">Billing</h2>
                    <h2 className="titlelinks">Settings</h2>
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
)(withRouter(HomePage));