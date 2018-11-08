import React, { Component } from "react";
import { Route, withRouter, Switch } from 'react-router-dom';

/////Dev Created/////////
import Signup from "./components/signup/signup";
import Login from "./components/login/login";

import "./App.css";

class App extends Component {
  render() {
    return (
      <div className="App">
        <div className="main-container">
          <h1>MealHelper</h1>
          <h3>Under construction</h3>
          <div className="signin">
            <Switch>
              <Route exact path='/signup' 
              render={() => 
              (<Signup
                />)}
              />
              <Route exact path='/login' 
              render={() => 
              (<Login
                />)}
              />
            </Switch>
          </div>
        </div>
      </div>
    );
  }
}

export default App;
