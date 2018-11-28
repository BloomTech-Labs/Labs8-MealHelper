import React from "react";
import Axios from "axios";

function delay() {
  // `delay` returns a promise
  return new Promise(function(resolve, reject) {
    // Only `delay` is able to resolve or reject the promise
    setTimeout(function() {
      resolve(42); // After 3 seconds, resolve the promise with value 42
    }, 1000);
  });
}

async function findNutrients(props) {
  const { foods } = props;
  await delay();
  for (let i = 0; i < foods.length; i++) {
    let req_ndbno = foods.map(item => {
      return item.ndbno;
    });

    console.log(req_ndbno);

    let nutrientArray = [];
    req_ndbno.map((nutrient_id, index) => {
      Axios.get(
        `https://api.nal.usda.gov/ndb/nutrients/?format=json&api_key=c24xU3JZJhbrgnquXUNlyAGXcysBibSmESbE3Nl6&nutrients=208&nutrients=203&nutrients=204&nutrients=205&ndbno=${nutrient_id}`
      ).then(response => {
        nutrientArray[index] = response.data.report.foods;
      });
    });
    await delay();
    return nutrientArray;
  }
  //   let req_ndbno = props.list.item.map(item => {
  //     return item.ndbno;
  //   });
}

export default function SelectedFoods(props) {
  console.log(props);

  let foodsSearch = findNutrients(props);
  console.log(foodsSearch.json());
  const { foods } = props;
  const foodRows = foods.map((food, idx) => (
    <tr
      food={food}
      key={food.offset}
      name={food.name}
      //   kcal={food.nutrients[0].value}
      //   protein_g={food.nutrients[1].value}
      //   fat_g={food.nutrients[2].value}
      //   carbohydrate_g={food.nutrients[3].value}
      onClick={() => props.onFoodClick(idx)}
    >
      <td>{food.name}</td>
      <td className="right aligned">{food.kcal}</td>
      <td className="right aligned">{food.protein_g}</td>
      <td className="right aligned">{food.fat_g}</td>
      <td className="right aligned">{food.carbohydrate_g}</td>
    </tr>
  ));

  return (
    <table className="ui selectable structured large table">
      <thead>
        <tr>
          <th colSpan="5">
            <h3>Selected foods</h3>
          </th>
        </tr>
        <tr>
          <th className="eight wide">Description</th>
          <th>Kcal</th>
          <th>Protein (g)</th>
          <th>Fat (g)</th>
          <th>Carbs (g)</th>
        </tr>
      </thead>
      <tbody>{foodRows}</tbody>
      <tfoot>
        <tr>
          <th>Total</th>
          <th className="right aligned" id="total-kcal">
            {sum(foods, "kcal")}
          </th>
          <th className="right aligned" id="total-protein_g">
            {sum(foods, "protein_g")}
          </th>
          <th className="right aligned" id="total-fat_g">
            {sum(foods, "fat_g")}
          </th>
          <th className="right aligned" id="total-carbohydrate_g">
            {sum(foods, "carbohydrate_g")}
          </th>
        </tr>
      </tfoot>
    </table>
  );
}

function sum(foods, prop) {
  return foods
    .reduce((memo, food) => parseInt(food[prop], 10) + memo, 0.0)
    .toFixed(2);
}
