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
import Weather from "./components/weather/weather";
import Recipes from "./components/recipes/recipes";
import MyRecipes from "./components/recipes/myrecipes";
import RecipeBook from "./components/recipebook/recipebook";
import CreateNewRecipe from "./components/creatnewrecipe/createnewrecipe";
import MyIngredients from "./components/recipes/myrecipe";
import MyWeather from "./components/weather/myweather";
import MyAlarms from "./components/alarms/myAlarms";
import AddAlarms from "./components/alarms/addAlarm";
import Billing from "./components/billing/billing";
import SettingsMain from "./components/Settings/SettingsMain";
import Zip from "./components/zip/zip";

////////////////////////

import Callback from "./Callback";
import Sign from "./components/Sign";

import "./App.css";
import LandingPage from "./components/landingpage/landingpage";
import EditEmail from "../Settings/EditEmail";
import EditPassword from "../Settings/EditPassword";
import EditZip from "../Settings/EditZip";

class App extends Component {
  render() {
    return (
      <div className="App">
      <h1>INSIDE APP.JS</h1>
        {/* <Switch>
          <Route exact path="/" render={() => <LandingPage />} />
          <Route path="/signup" render={() => <Signup />} />
          <Route path="/callback" render={() => <Callback />} />
          <Route path="/login" render={() => <Login />} />
          <Route path="/zip" render={() => <Zip />} />
          <Route exact path="/homepage" render={() => <HomePage />} />
          
          <Route path="/homepage/weather" render={() => <Weather />} />
          <Route exact path="/ingredients" render={() => <GetIngredient />} />
          
          <Route path="/homepage/billing" render={() => <Billing />} />
          <Route 
            path="/homepage/recipes/createnewrecipe"
            render={() => <CreateNewRecipe />}
          />
          <Route
            path="/homepage/ingredients/myingredients"
            render={() => <MyIngredients />}
          />
          <Route
            path="/homepage/weather/myweather"
            render={() => <MyWeather />}
          />
          <Route
            path="/homepage/recipes/myrecipes"
            render={() => <MyRecipes />}
          />
          <Route
            path="/homepage/recipes/recipebook"
            render={() => <RecipeBook />}
          />

          <Route
            path="/homepage/ingredients/myingredients"
            render={() => <MyIngredients />}
          />
          <Route path="/homepage/alarms" render={() => <MyAlarms />} />
          <Route
            path="/homepage/alarms/add-alarms"
            render={() => <AddAlarms />}
          />
          <Route
            path="/homepage/alarms/add-alarms"
            render={() => <AddAlarms />}
          />
          <Route path="/homepage/settings" render={() => <SettingsMain />} />
          <Route path="/homepage/settings/email" render={() => <EditEmail />} />
          <Route
            path="/homepage/settings/password"
            render={() => <EditPassword />}
          />
          <Route path="/homepage/settings/zip" render={() => <EditZip />} />
        </Switch> */}
      </div>
    );
  }
}

export default App;
