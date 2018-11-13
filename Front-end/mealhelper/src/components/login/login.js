import React, { Component } from "react";
import './login.css';


class Login extends Component {

    // handleChange = event => {
    //     event.preventDefault();
    //     this.setState({
    //       user: {
    //         ...this.state.note,
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
                <div class="login login-two">
                    <span>Login</span>
                </div>
            </form>
        </div>
    );
  }
}

export default Login;