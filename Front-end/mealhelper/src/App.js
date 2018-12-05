/////Static Imports/////////
import React, { Component } from "react";
import { Route, Switch, Link } from "react-router-dom";
//////////////////////////

/////Dev. Created/////////

// import LandingPage from "./components/landingpage/landingpage";
import GetIngredient from "./components/ingredients/getIngredient";
import Signup from "./components/signup/signup";
import Login from "./components/login/login";
import Meals from "./components/Meals/Meals";
import HomePage from "./components/homepage/homepage";

import Zip from "./components/zip/zip";


import NavbarMain from "./components/Navbar/NavbarMain";
import Display from "./components/display/display";
////////////////////////

import Callback from "./Callback";
import Sign from "./components/Sign";

import "./App.css";
import LandingPage from "./components/landingpage/landingpage";


class App extends Component {
  render() {
    return (
      <div className="App">
      {/* <NavbarMain />
      <Display /> */}
        	<Switch>
          <Route exact path="/" render={() => <LandingPage />} />
          <Route path="/signup" render={() => <Signup />} />
          <Route path="/callback" render={() => <Callback />} />
          <Route path="/login" render={() => <Login />} />
          <Route path="/zip" render={() => <Zip />} />
          <Route exact path="/homepage" render={() => <HomePage />} />
          <Route exact path="/ingredients" render={() => <GetIngredient />} />
          <Route path="/homepage/meals" render={() => <Meals />} />
        </Switch>
      </div>
    );
  }
}

export default App;
