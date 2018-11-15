import React, { Component } from "react";
import './signup.css';
import axios from "axios";

class Signup extends Component {
    /////REMOVE THIS IN THE SECOND WEEK
    constructor(props) {
        super(props);
        this.state = {
          users: [],
          user: 
          {
            email: '',
            password: '',
            zip:'',
            healthCondition:''
          },
        };
      }

    handleChange = event => {
        event.preventDefault();
        this.setState({
          user: {
            ...this.state.users,
            [event.target.name]: event.target.value,
          }
        });
      };

    handleAddNewUser = event => {
        event.preventDefault();
        console.log('firing');
         axios
        .post('https://labs8-meal-helper.herokuapp.com/register', this.state.user)
        .then(response => this.setState({user: response.data }), window.location ="/thanks")
        console.log(this.state.user);
    };


  render() {
    return (
        <div className="form">
            <h1 className="signup-title">Sign Up</h1>
                <form>
                <div className="form-group">
                    <input type="text" id="dynamic-label-input" placeholder="Email" onChange={this.handleChange}/>
                    <label htmlFor="dynamic-label-input">Email</label>
                </div>
                <div className="form-group">
                    <input type="password" id="dynamic-label-input" placeholder="Password" onChange={this.handleChange}/>
                    <label htmlFor="dynamic-label-input">Password</label>
                </div>
                <div className="form-group">
                    <input type="text" id="dynamic-label-input" placeholder="Zip"onChange={this.handleChange}/>
                    <label htmlFor="dynamic-label-input">Zip</label>
                </div>
                <div className="form-group">
                    <input type="text" id="dynamic-label-input" placeholder="Health Condition" onChange={this.handleChange}/>
                    <label htmlFor="dynamic-label-input">Health Condition</label>
                </div>
                <div className="signup signup-two" onClick={this.handleAddNewUser}>
                    <span>Sign Up</span>
                </div>
            </form>
        </div>
    );
  }
}

export default Signup;