/////Static Imports/////////
import React, { Component } from 'react';
import { Route, Switch, Link } from 'react-router-dom';
//////////////////////////

/////Dev. Created/////////
import Signup from './components/signup/signup';
import Login from './components/login/login';
import HomePage from './components/homepage/homepage';
import Weather from './components/weather/weather';
import Recipes from './components/recipes/recipes';
// import LandingPage from "./components/landingpage/landingpage";
import MyIngredients from './components/recipes/myrecipe';
import MyWeather from './components/weather/myweather';
import GetIngredient from './components/ingredients/getIngredient';
////////////////////////

import Callback from './Callback';
import Sign from './components/Sign';

import './App.css';

class App extends Component {
	render() {
		return (
			<div className="App">
				<Switch>
					{/* <Route exact path="/" render={() => <LandingPage />} /> */}
					<Route exact path="/" render={() => <Signup />} />
					<Route path="/callback" render={() => <Callback />} />
					<Route path="/login" render={() => <Login />} />
					<Route exact path="/homepage" render={() => <HomePage />} />
					<Route exact path="/homepage/weather" render={() => <Weather />} />
					<Route path="/homepage/weather/myweather" render={() => <MyWeather />} />
					<Route path="/ingredients" render={() => <GetIngredient />} />
					<Route path="/homepage/recipes" render={() => <Recipes />} />
					<Route path="/homepage/ingredients/myingredients" render={() => <MyIngredients />} />
				</Switch>
			</div>
		);
	}
}

export default App;
