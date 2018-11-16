import React, { Component } from "react";
import { connect } from "react-redux";
import { loginUser } from "../../store/actions/userActions";
import { withRouter, Link } from "react-router-dom";
import { Alert } from "reactstrap";

class Login extends Component {
	constructor(props) {
		super(props);

		this.state = {
			email: "",
			password: "",
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
			const { email, password } = this.state;
			const user = { email, password };
			this.props.loginUser(user);
			this.props.history.push("/homepage");
		}
	};

	render() {
		return (
			<div className="main-container">
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
				<div className="user-form-container">
					<form className="forms">
						<input
							className="email-input"
							type="text-title"
							name="email"
							value={this.state.email}
							onChange={this.handleChange}
							placeholder="Email"
							required
						/>
						<input
							className="password-input"
							type="password"
							name="password"
							onChange={this.handleChange}
							value={this.state.password}
							placeholder="Password"
							required
						/>
						<div className="alert-box">
							<Alert isOpen={this.state.visable} color="danger">
								Please enter an email and address
							</Alert>
						</div>

						<button onClick={this.createUser} className="savenote-button">
							Save
						</button>
					</form>
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
	{ loginUser }
)(withRouter(Login));
