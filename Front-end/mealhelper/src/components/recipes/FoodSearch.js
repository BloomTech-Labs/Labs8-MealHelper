import React from "react";
import Client from "./Client";

const MATCHING_ITEM_LIMIT = 5;

class FoodSearch extends React.Component {
  state = {
    foods: [],
    showRemoveIcon: false,
    searchValue: ""
  };

  handleSearchChange = e => {
    const value = e.target.value;

    this.setState({
      searchValue: value
    });

    if (value === "") {
      this.setState({
        foods: [],
        showRemoveIcon: false
      });
    } else {
      this.setState({
        showRemoveIcon: true
      });

      Client.search(value, foods => {
        if (foods.errors) {
          this.setState({
            foods: [{ name: "No food was found with that name" }]
          });
        } else {
          this.setState({
            foods: foods.list.item.slice(0, MATCHING_ITEM_LIMIT)
          });
        }
      });
    }
  };

  handleSearchCancel = () => {
    this.setState({
      foods: [],
      showRemoveIcon: false,
      searchValue: ""
    });
  };

  render() {
    const { showRemoveIcon, foods } = this.state;
    const removeIconStyle = showRemoveIcon ? {} : { visibility: "hidden" };

    const foodRows = foods.map((food, index, idx) => (
      <tr
        food={food}
        key={food.offset}
        name={food.name}
        onClick={() => this.props.onFoodClick(food)}
      >
        <td>{food.name}</td>

        {/* <td className="right aligned">{nutrientsValue[0].value}</td>
				<td className="right aligned">{nutrientsValue[1].value}</td>
				<td className="right aligned">{nutrientsValue[2].value}</td> */}
      </tr>
    ));

    return (
      <div id="food-search">
        <table className="ui selectable structured large table">
          <thead>
            <tr>
              <th colSpan="5">
                <div className="ui fluid search">
                  <div className="ui icon input">
                    <input
                      className="prompt"
                      type="text"
                      placeholder="Search foods..."
                      value={this.state.searchValue}
                      onChange={this.handleSearchChange}
                    />
                    <i className="search icon" />
                  </div>
                  <i
                    className="remove icon"
                    onClick={this.handleSearchCancel}
                    style={removeIconStyle}
                  />
                </div>
              </th>
            </tr>
            <tr>
              <th className="eight wide">Food Name</th>
            </tr>
          </thead>
          <tbody>{foodRows}</tbody>
        </table>
      </div>
    );
  }
}

export default FoodSearch;
