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
	};;

    loginUser = event => {
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


const mapStateToProps = state => ({
	user: state.user
});

export default connect(
	mapStateToProps,
	{ GETTING_USER }
)(withRouter(Login));