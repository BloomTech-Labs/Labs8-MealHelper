import React from "react";
import { Link, withRouter } from "react-router-dom";
import auth0Client from "../Auth";
import Authlogo from "../img/auth0.png";

function Sign(props) {
	const signOut = () => {
		auth0Client.signOut();
		props.history.replace("/");
	};

	return (
		<nav>
			{!auth0Client.isAuthenticated() && (
				<button className="login-button" onClick={auth0Client.signIn}>
					{Authlogo}
				</button>
			)}
			{auth0Client.isAuthenticated() && (
				<div>
					<label className="mr-2 text-black">
						{auth0Client.getProfile().name}
					</label>
					<button
						className="login-button"
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
