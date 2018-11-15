import React from "react";
import './login.css';


const Login = ({ onClick }) => (

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
                <div className="login login-two" onClick= { onClick }>
                    <span>Login</span>
                </div>
            </form>
        </div>
    );

export default Login;