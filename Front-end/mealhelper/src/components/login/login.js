import React from "react";
import './login.css';


const Login = ({}) => (
    /////REMOVE THIS IN THE SECOND WEEK
    // constructor(props) {
    //     super(props);
    //     this.state = {
    //       users: [],
    //       user: 
    //       {
    //         email: '',
    //         password: ''
    //       },
    //     };
    //   }

    // handleChange = event => {
    //     event.preventDefault();
    //     this.setState({
    //       user: {
    //         ...this.state.user,
    //         [event.target.name]: event.target.value,
    //       }
          
    //     });
    //   };

    // handleAddNewUser = event => {
    //     event.preventDefault();
    //     // console.log('firing');
    //      axios
    //     .post('https://labs8-meal-helper.herokuapp.com/users/login', this.state.users)
    //     .then(response => this.setState({user: response.data }), window.location ="/thanks")
    // };

        <div className="form-title">
            <h1 className="login-title">Login</h1>
            <form>
                <div className="form-group">
                    <input type="text" id="dynamic-label-input" placeholder="Email"/>
                    <label htmlFor="dynamic-label-input">Email</label>
                </div>
                <div className="form-group">
                    <input type="password" id="dynamic-label-input" placeholder="Password" />
                    <label htmlFor="dynamic-label-input">Password</label>
                </div>
                <div className="login login-two">
                    <span>Login</span>
                </div>
            </form>
        </div>
    );

export default Login;