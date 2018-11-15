import React, { Component } from "react";
import { withRouter } from "react-router-dom";
import { connect } from "react-redux";
//change the route for this
import { loginAuthUser } from "./store/actions/userActions";
import auth0Client from "./Auth";

class Callback extends Component {
	async componentDidMount() {
		await auth0Client.handleAuthentication();
		//Replace with /homepage
		const email = localStorage.getItem("email");
		const user = { email };
		this.props.loginAuthUser(user);
		console.log(this.props);
		this.props.history.replace("/homepage");
	}

	render() {
		return <p>Loading profile...</p>;
	}
}
const mapStateToProps = state => ({
	user: state.user
});
export default connect(
	mapStateToProps,
	{ loginAuthUser }
)(withRouter(Callback));
