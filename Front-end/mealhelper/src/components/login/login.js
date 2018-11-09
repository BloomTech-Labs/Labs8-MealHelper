import React, { Component } from "react";
import axios from "axios";
import './login.css';


class Login extends Component {

    handleChange = event => {
        event.preventDefault();
        this.setState({
          user: {
            ...this.state.user,
            [event.target.name]: event.target.value,
          }
          
        });
      };

    handleAddNewUser = event => {
        event.preventDefault();
        console.log('firing');
         axios
        .post('https://labs8-meal-helper.herokuapp.com/users', this.state.users)
        .then(response => this.setState({user: response.data }), window.location ="/thanks")
    };


  render() {
    return (
        <div className="form-title">
            <h1 className="login-title">Login</h1>
            <form>
                <div className="form-group">
                    <input type="text" id="dynamic-label-input" placeholder="Email" onChange={this.handleChange}/>
                    <label htmlFor="dynamic-label-input">Email</label>
                </div>
                <div className="form-group">
                    <input type="password" id="dynamic-label-input" placeholder="Password" onChange={this.handleChange}/>
                    <label htmlFor="dynamic-label-input">Password</label>
                </div>
                <div className="login login-two" onClick={this.handleAddNewUser}>
                    <span>Login</span>
                </div>
            </form>
        </div>
    );
  }
}

export default Login;