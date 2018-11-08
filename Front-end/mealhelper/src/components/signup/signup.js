import React, { Component } from "react";
import './signup.css';

class Signup extends Component {
  render() {
    return (
        <div className="form">
          <h1>Sign Up</h1>
          <form>
            <div className="form-group">
                <input type="text" id="dynamic-label-input" placeholder="Email"/>
                    <label htmlFor="dynamic-label-input">Email</label>
            </div>
            <div className="form-group">
                <input type="password" id="dynamic-label-input" placeholder="Password"/>
                    <label htmlFor="dynamic-label-input">Password</label>
            </div>
            <div className="form-group">
                <input type="text" id="dynamic-label-input" placeholder="Zip"/>
                    <label htmlFor="dynamic-label-input">Zip</label>
            </div>
            <div className="form-group">
                <input type="text" id="dynamic-label-input" placeholder="Health Condition"/>
                    <label htmlFor="dynamic-label-input">Health Condition</label>
            </div>
          </form>
          </div>
    );
  }
}

export default Signup;