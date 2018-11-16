import React, { Component } from "react";
import { connect } from "react-redux";
//change the route for this
import { addUser } from "../../store/actions/userActions";
import { withRouter, Link, Route } from "react-router-dom";
// import { Alert } from "reactstrap";
import Sign from "../../components/Sign";
import Callback from "../../Callback";
import "./landingpage.css";

class Landingpage extends Component {
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
			<div className="main-container">
				<div>
					<Sign />
					<Route exact path="/callback" component={Callback} />
				</div>
				<div className="entry-button-group">
					<Link to="/signup">
						<button className="signup-button">
							<span>Signup</span>
						</button>
					</Link>
					<Link to="/login">
						<button className="login-button">
							<span>Login</span>
						</button>
					</Link>
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
)(withRouter(Landingpage));
