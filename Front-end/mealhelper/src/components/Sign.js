import React from "react";
import { Link, withRouter } from "react-router-dom";
import auth0Client from "../Auth";

function Sign(props) {
	const signOut = () => {
		auth0Client.signOut();
		props.history.replace("/");
	};

	return (
		<nav className="navbar">
			{!auth0Client.isAuthenticated() && (
				<button className="btn btn-dark" onClick={auth0Client.signIn}>
					Sign Up With Auth0
				</button>
			)}
			{auth0Client.isAuthenticated() && (
				<div>
					<label className="mr-2 text-black">
						{auth0Client.getProfile().name}
					</label>
					<button
						className="btn btn-dark"
						onClick={() => {
							signOut();
						}}
					>
						Sign Out
					</button>
				</div>
			)}
		</nav>
	);
}

export default withRouter(Sign);