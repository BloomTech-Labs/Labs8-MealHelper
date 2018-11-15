import auth0 from "auth0-js";
import { connect } from "react-redux";
//change the route for this
import { addUser } from "./store/actions/userActions";
import { withRouter } from "react-router-dom";

class Auth {
	constructor() {
		this.auth0 = new auth0.WebAuth({
			domain: "meal-helper.auth0.com",
			audience: "https://meal-helper.auth0.com/userinfo",
			clientID: "8tgiI3YtUYxGba-t1sgTpV9xJKyMLgaW",
			redirectUri: "http://localhost:3000/callback",
			responseType: "token id_token",
			scope: "openid email profile"
		});

		this.getProfile = this.getProfile.bind(this);
		this.handleAuthentication = this.handleAuthentication.bind(this);
		this.isAuthenticated = this.isAuthenticated.bind(this);
		this.signIn = this.signIn.bind(this);
		this.signOut = this.signOut.bind(this);
	}

	getProfile() {
		return this.profile;
	}

	getIdToken() {
		return this.idToken;
	}

	isAuthenticated() {
		return new Date().getTime() < this.expiresAt;
	}

	signIn() {
		this.auth0.authorize();
	}

	handleAuthentication() {
		return new Promise((resolve, reject) => {
			this.auth0.parseHash((err, authResult) => {
				if (err) return reject(err);
				if (!authResult || !authResult.idToken) {
					return reject(err);
				}
				this.idToken = authResult.idToken;
				this.profile = authResult.idTokenPayload;
				console.log(this.profile);
				//Checks to see if an email is returnd
				if (this.profile.email !== "") {
					const { email } = this.profile.email;
					const user = { email };
					// this.props.addUser(user);
				} else {
					//Else set the full name as "email" and send that
					const { email } = this.profile.name;
					const user = { email };
					// this.props.addUser(user);
				}

				this.expiresAt = authResult.expiresIn * 1000 + new Date().getTime();
				resolve();
			});
		});
	}

	signOut() {
		this.idToken = null;
		this.profile = null;
		this.expiresAt = null;
	}
}

const auth0Client = new Auth();

const mapStateToProps = state => ({
	user: state.user
});

export default connect(
	mapStateToProps,
	{ addUser }
)(withRouter(auth0Client));
