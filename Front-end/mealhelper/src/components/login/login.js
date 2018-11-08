import React, { Component } from "react";
import './login.css';


class Login extends Component {
  render() {
    return (
        <div className="form-title">
        <h1 className="login-title">Login</h1>
        <form>
          <div className="form-group">
              <input type="text" id="dynamic-label-input" placeholder="Email"/>
                  <label htmlFor="dynamic-label-input">Email</label>
          </div>
          <div className="form-group">
              <input type="password" id="dynamic-label-input" placeholder="Password"/>
                  <label htmlFor="dynamic-label-input">Password</label>
          </div>
        </form>
        </div>
    );
  }
}

export default Login;