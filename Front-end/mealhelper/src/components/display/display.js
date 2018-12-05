// == Dependencies == //
import React, { Component } from "react";
import { connect } from "react-redux";
import { withRouter, Route, Switch } from "react-router-dom";
// == Actions == //
import { addUser } from "../../store/actions/userActions";
// == Components == //
import HomePage from "../homepage/homepage";
import Meals from "../Meals/Meals";
import Recipes from "../recipes/recipes";
import RecipeBook from "../recipebook/recipebook";
import MyRecipes from "../recipes/myrecipes";
import CreateNewRecipe from "../creatnewrecipe/createnewrecipe";
import MyIngredients from "../recipes/myrecipe";
import Weather from "../weather/weather";
import MyWeather from "../weather/myweather";
import MyAlarms from "../alarms/myAlarms";
import AddAlarms from "../alarms/addAlarm";
import SettingsMain from "../Settings/SettingsMain";
import EditEmail from "../Settings/EditEmail";
import EditPassword from "../Settings/EditPassword";
import EditZip from "../Settings/EditZip";
import Billing from "../billing/billing";
import MealDisplay from "./MealDisplay";
import RecipeDisplay from "./RecipeDisplay";
import NavbarMain from "../Navbar/NavbarMain";
// == Styles == //
import "../homepage/homepage.css";

class Display extends Component {
  render() {
    return (
      <div className="this-badboy-can-hold-so-many-components">
     <h1>HELLO I'M DISPLAY</h1>
      <Switch>
        {/* <Route exact path="/homepage" render={() => <HomePage />} /> */}
     
        
        <Route exact path="/homepage/recipes" render={() => <Recipes />} />
        <Route path="/homepage/recipes/recipebook" render={() => <RecipeBook />} />
        <Route path="/homepage/recipes/myrecipes" render={() => <MyRecipes />} />
        <Route path="/homepage/recipes/createnewrecipe" render={() => <CreateNewRecipe />} />
        <Route path="/homepage/ingredients/myingredients" render={() => <MyIngredients />} />

        <Route exact path="/homepage/weather" render={() => <Weather />} />
        
        <Route exact path="/homepage/alarms" render={() => <MyAlarms/>} />
        <Route path="/homepage/alarms/add-alarms" render={() => <AddAlarms />}/>
        
        <Route path="/homepage/billing" render={() => <Billing />} />
        
        <Route path="/homepage/weather/myweather" render={() => <MyWeather />} />
        
        <Route exact path="/homepage/settings" render={() => <SettingsMain />} />
        <Route path="/homepage/settings/email" render={() => <EditEmail />} />
        <Route path="/homepage/settings/password" render={() => <EditPassword />} />
        <Route path="/homepage/settings/zip" render={() => <EditZip />} />
      </Switch>
      </div>
    );
  }
}

const mapStateToProps = state => ({
  user: state.userReducer.user,
  meals: state.mealsReducer.meals
});

export default connect(
  mapStateToProps,
  { addUser }
)(withRouter(Display));
