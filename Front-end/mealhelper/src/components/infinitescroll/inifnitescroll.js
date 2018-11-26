import React, { Component, Fragment } from "react";
import { render } from "react-dom";

class InfiniteScroll extends Component {
  constructor(props) {
    super(props);
    
    // Sets up our initial state
    this.state = {
      error: false,
      hasMore: true,
      isLoading: false,
      recipe: [],
    };

    // Binds our scroll event handler
    window.onscroll = () => {
      const {
        loadRecipes,
        state: {
          error,
          isLoading,
          hasMore,
        },
      } = this;

      // Notifys if:
      // * there's an error
      // * it's already loading
      // * there's nothing left to load
      if (error || isLoading || !hasMore) return;

      // Checks that the page has scrolled to the bottom
      if (
        window.innerHeight + document.documentElement.scrollTop
        === document.documentElement.offsetHeight
      ) {
        loadRecipes();
      }
    };
  }

  componentWillMount() {
    // Loads some recipes initial load
    this.loadRecipes();
  }

  loadRecipes = () => {
    this.setState({ isLoading: true }, () => {
      request
        .get('https://labs8-meal-helper.herokuapp.com/users/:userid/meals?results=5')
        .then((results) => {          
          // Creates a massaged array of user data
          const nextRecipes = results.body.results.map(user => ({
            name: recipe.name,
            calories: recipe.calories,
            servings: recipe.servings,
          }));

          // Merges the next recipes into existing recipes
          this.setState({
            // Check to see if API returns this value. May be
            // returned as part of the payload to indicate that there is no
            // additional data to be loaded
            hasMore: (this.state.recipes.length < 100),
            isLoading: false,
            recipes: [
              ...this.state.recipes,
              ...nextRecipes,
            ],
          });
        })
        .catch((err) => {
          this.setState({
            error: err.message,
            isLoading: false,
           });
        })
    });
  }

  render() {
    const {
      error,
      hasMore,
      isLoading,
      users,
    } = this.state;

    return (
      <div>
        <p>Scroll down to load more recipes!!</p>
        {recipes.map(recipe => (
          <Fragment key={recipe.name}>
            <hr />
              <div>
                <h2 style={{ marginTop: 0 }}>
                  @{user.username}
                </h2>
                <p>Name: {recipe.name}</p>
                <p>Calories: {recipe.calories}</p>
                <p>Servings: {recipe.servings}</p>
              </div>
          </Fragment>
        ))}
        <hr />
        {error &&
          <div style={{ color: '#900' }}>
            {error}
          </div>
        }
        {isLoading &&
          <div>Loading...</div>
        }
        {!hasMore &&
          <div>There are no more recipes in your book</div>
        }
        {/* Include "click here" to add another */}
      </div>
    );
  }
}

const container = document.createElement("div");
document.body.appendChild(container);
render(<InfiniteScroll />, container);