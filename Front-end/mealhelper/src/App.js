/////Static Imports/////////
import React, { Component } from "react";
import { Route, Switch, Link } from "react-router-dom";
//////////////////////////

/////Dev. Created/////////
import Signup from "./components/signup/signup";
import Login from "./components/login/login";
<<<<<<< HEAD
import HomePage from "./components/homepage/homepage";
import Weather from "./components/weather/weather";
import Recipes from "./components/recipes/recipes";
import LandingPage from "./components/landingpage/landingpage";
=======
import Thanks from "./components/thanks/thanks";
>>>>>>> 04f91252d49f326144668bf0b6602bfbce9b5a4e
////////////////////////

import Callback from "./Callback";
import Sign from "./components/Sign";

import "./App.css";

class App extends Component {
	render() {
		return (
			<div className="App">
<<<<<<< HEAD
				<Switch>
					<Route exact path="/" render={() => <LandingPage />} />
					<Route path="/signup" render={() => <Signup />} />
					<Route path="/login" render={() => <Login />} />
					<Route path="/homepage" render={() => <HomePage />} />
					<Route path="/homepage/weather" render={() => <Weather />} />
					<Route path="/homepage/recipes" render={() => <Recipes />} />
				</Switch>
=======
				<div className="main-container">
					<div className="entry-button-group">
						<div>
							<Sign />
							<Route exact path="/callback" component={Callback} />
						</div>

						<Link to="/signup">
							<button className="signup-button">
								<span>Signup</span>
							</button>
						</Link>
						<Link to="/login">
							<button className="login-button">
								<span>Login</span>
							</button>
						</Link>
					</div>
					<div className="signin">
						<Switch>
							<Route exact path="/signup" render={() => <Signup />} />
							<Route path="/login" render={() => <Login />} />
							<Route path="/thanks" render={() => <Thanks />} />
						</Switch>
					</div>
				</div>
>>>>>>> 04f91252d49f326144668bf0b6602bfbce9b5a4e
			</div>
		);
	}
}

export default App;
