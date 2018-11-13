<<<<<<< HEAD
import React, { Component } from "react";
import { connect } from "react-redux";
import { loginUser } from "../../store/actions/userActions";
import { withRouter } from "react-router-dom";
import { Alert } from "reactstrap";

class Login extends Component {
	constructor(props) {
=======
<<<<<<< HEAD
import React, { Component } from "react";
import { connect } from 'react-redux';
import { GETTING_USER } from '../../store/actions';
import { withRouter } from "react-router-dom";
=======
import React from "react";
>>>>>>> 9d607623b715efe5262c6f68b95521792caaa2f8
import './login.css';


const Login = ({ onClick }) => (

<<<<<<< HEAD
    constructor(props) {
>>>>>>> 78e93935dcc638614756f6352ceae963ce17380a
		super(props);

		this.state = {
			email: "",
			password: "",
<<<<<<< HEAD
			visable: false
		};
	}

	handleChange = event => {
=======
			zip: null,
			healthCondition: "",
			visable: false
		};
    }
    
    handleChange = event => {
>>>>>>> 78e93935dcc638614756f6352ceae963ce17380a
		event.preventDefault();
		this.setState({
			[event.target.name]: event.target.value
		});
<<<<<<< HEAD
	};

	createUser = event => {
		event.preventDefault();
		if (!this.state.email || !this.state.password) {
			this.setState({ visable: true });
		} else {
			const { email, password } = this.state;
			const user = { email, password };
			this.props.loginUser(user);
=======
	};;

    loginUser = event => {
        event.preventDefault();
		if (!this.state.email || !this.state.password) {
			this.setState({ visable: true });
		} else {
			const { email, password, zip, healthCondition } = this.state;
			const user = { email, password, zip, healthCondition };
			this.props.addUser(user);
>>>>>>> 78e93935dcc638614756f6352ceae963ce17380a
			// this.props.history.push("/");
		}
	};

<<<<<<< HEAD
	render() {
		return (
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
		);
	}
}
=======
  render() {
    return (
=======
>>>>>>> 9d607623b715efe5262c6f68b95521792caaa2f8
        <div className="form-title">
            <h1 className="login-title">Login</h1>
            <form>
                <div className="form-group">
                    <input 
                        type="text" 
                        id="dynamic-label-input" 
                        placeholder="Email"
                        name="email"
                        value={this.state.email}
                        onChange={this.handleChange}
                        required
                    />
                    <label 
                        htmlFor="dynamic-label-input">
                        Email
                    </label>
                </div>
                <div className="form-group">
<<<<<<< HEAD
                    <input 
                        type="password" 
                        id="dynamic-label-input" 
                        placeholder="Password"
                        onChange={this.handleChange}
                        value={this.state.password}
                        required
                    />
                    <label 
                        htmlFor="dynamic-label-input">
                        Password
                    </label>
=======
                    <input type="password" id="dynamic-label-input" placeholder="Password" />
                    <label htmlFor="dynamic-label-input">Password</label>
>>>>>>> 9d607623b715efe5262c6f68b95521792caaa2f8
                </div>
                <div className="login login-two" onClick= { onClick }>
                    <span>Login</span>
                </div>
            </form>
        </div>
    );

>>>>>>> 78e93935dcc638614756f6352ceae963ce17380a

const mapStateToProps = state => ({
	user: state.user
});

export default connect(
	mapStateToProps,
<<<<<<< HEAD
	{ loginUser }
)(withRouter(Login));
=======
	{ GETTING_USER }
)(withRouter(Login));
>>>>>>> 78e93935dcc638614756f6352ceae963ce17380a
