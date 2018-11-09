import React, { Component } from "react";
import './signup.css';

class Signup extends Component {

    // handleChange = event => {
    //     event.preventDefault();
    //     this.setState({
    //       note: {
    //         ...this.state.user,
    //         [event.target.name]: event.target.value,
    //       }
          
    //     });
    //   };

    // handleAddNewUser = event => {
    //     event.preventDefault();
    //     // console.log('firing');
    //      axios
    //     .post('http://localhost:9000/users', this.state.users)
    //     .then(response => this.setState({user: response.data }), window.location ="/thanks")
    // };


  render() {
    return (
        <div className="form">
            <h1 className="signup-title">Sign Up</h1>
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
                <div class="login login-two">
                    <span>Login</span>
                </div>
            </form>
        </div>
    );
  }
}

export default Signup;