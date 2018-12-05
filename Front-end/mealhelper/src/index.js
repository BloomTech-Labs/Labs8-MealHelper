import React from "react";
import ReactDOM from "react-dom";
import "./index.css";
import App from "./App";
import * as serviceWorker from "./serviceWorker";
import "bootstrap/dist/css/bootstrap.min.css";
import "semantic-ui-css/semantic.min.css";
import { Provider } from "react-redux";
import { createStore, applyMiddleware } from "redux";
import thunk from "redux-thunk";
import logger from "redux-logger";
import { BrowserRouter as Router, Route, Switch } from "react-router-dom";

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
import Callback from "./Callback";
import Sign from "./components/Sign";
import LandingPage from "./components/landingpage/landingpage";
import EditEmail from "./components/Settings/EditEmail";
import EditPassword from "./components/Settings/EditPassword";
import EditZip from "./components/Settings/EditZip";

import rootReducer from "./store/reducers";

const store = createStore(rootReducer, applyMiddleware(thunk, logger));

ReactDOM.render(
	<Provider store={store}>
		<Router>
			{/* <App /> */}
			<Switch>
          <Route exact path="/" render={() => <LandingPage />} />
          <Route path="/signup" render={() => <Signup />} />
          <Route path="/callback" render={() => <Callback />} />
          <Route path="/login" render={() => <Login />} />
          <Route path="/zip" render={() => <Zip />} />
          <Route path="/homepage" render={() => <HomePage />} />
          <Route exact path="/ingredients" render={() => <GetIngredient />} />
          
          
        </Switch>
		</Router>
	</Provider>,
	document.getElementById("root")
);

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: http://bit.ly/CRA-PWA
serviceWorker.unregister();
