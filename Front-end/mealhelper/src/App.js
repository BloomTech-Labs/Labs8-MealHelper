// == Dependencies == //
import React, { Component } from "react";
import { Route, Switch, Link } from "react-router-dom";
// == Components == //
import Navbar from "./components/Navbar/Navbar";
import LandingPage from "./components/landingpage/landingpage";
import Login from "./components/login/login";
import Signup from "./components/signup/signup";
import Zip from "./components/zip/zip";
import Callback from "./Callback";
import NavbarMain from "./components/Navbar/NavbarMain";
import HomePage from "./components/homepage/homepage";
import Meals from "./components/Meals/Meals";
import NewMeals from "./components/Meals/NewMeal";
import Recipes from "./components/recipes/recipes";
import GetStarted from "./components/getstarted/getstarted";
import MyRecipes from "./components/recipes/myrecipe";
import CreateNewRecipe from "./components/creatnewrecipe/createnewrecipe";
import SingleRecipe from "./components/recipes/SingleRecipe";
import RecipeEdit from "./components/creatnewrecipe/EditRecipe";
import GetIngredient from "./components/ingredients/getIngredient";
import Weather from "./components/weather/weather";
import MyWeather from "./components/weather/myweather";
import MyAlarms from "./components/alarms/myAlarms";
import AddAlarms from "./components/alarms/addAlarm";
import SettingsMain from "./components/Settings/SettingsMain";
import EditEmail from "./components/Settings/EditEmail";
import EditPassword from "./components/Settings/EditPassword";
import EditZip from "./components/Settings/EditZip";
import Billing from "./components/billing/billing";
// == Styles == //
import "./App.css";

class App extends Component {
  render() {
    return (
      <div className="App">
        <NavbarMain />
        <div className="display">
          <Switch>
            <Route exact path="/" render={() => <LandingPage />} />
            <Route path="/signup" render={() => <Signup />} />
            <Route path="/callback" render={() => <Callback />} />
            <Route path="/login" render={() => <Login />} />
            <Route path="/zip" render={() => <Zip />} />

            <Route exact path="/ingredients" render={() => <GetIngredient />} />
            <Route exact path="/homepage" render={() => <HomePage />} />
            <Route
              exact
              path="/homepage/getstarted"
              render={() => <GetStarted />}
            />
            <Route exact path="/homepage/meals" render={() => <Meals />} />
            <Route path="/homepage/meals/new" render={() => <NewMeals />} />
            <Route exact path="/homepage/recipes" render={() => <Recipes />} />

            <Route
              path="/homepage/recipes/myrecipes"
              render={() => <MyRecipes />}
            />
            <Route
              path="/homepage/recipes/createnewrecipe"
              render={() => <CreateNewRecipe />}
            />
            <Route
              path="/recipe/:recipeid/edit"
              render={() => <RecipeEdit />}
            />
            <Route path="/recipe/:id" render={() => <SingleRecipe />} />
            <Route exact path="/homepage/weather" render={() => <Weather />} />
            <Route
              path="/homepage/weather/myweather"
              render={() => <MyWeather />}
            />

            <Route exact path="/homepage/alarms" render={() => <MyAlarms />} />
            <Route
              path="/homepage/alarms/add-alarms"
              render={() => <AddAlarms />}
            />

            <Route path="/homepage/billing" render={() => <Billing />} />

            <Route
              exact
              path="/homepage/settings"
              render={() => <SettingsMain />}
            />
            <Route
              path="/homepage/settings/email"
              render={() => <EditEmail />}
            />
            <Route
              path="/homepage/settings/password"
              render={() => <EditPassword />}
            />
            <Route path="/homepage/settings/zip" render={() => <EditZip />} />
            <Route exact path="/homepage/alarms" render={() => <MyAlarms />} />
            <Route
              path="/homepage/alarms/add-alarms"
              render={() => <AddAlarms />}
            />
          </Switch>
        </div>
      </div>
    );
  }
}

export default App;
