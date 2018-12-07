/* eslint-disable no-undef */
import axios from "axios";
async function search(query, cb) {
  return fetch(
    `https://api.nal.usda.gov/ndb/search/?format=json&It=f&q=${query}&sort=n&max=5&offset=0&api_key=c24xU3JZJhbrgnquXUNlyAGXcysBibSmESbE3Nl6`,
    {
      accept: "application/json"
    }
  )
    .then(checkStatus)
    .then(await parseJSON)
    .then(await getNutrients)
    .then(cb);
}

function checkStatus(response) {
  if (response.status >= 200 && response.status < 300) {
    return response;
  }
  const error = new Error(`HTTP Error ${response.statusText}`);
  error.status = response.statusText;
  error.response = response;
  console.log(error); // eslint-disable-line no-console
  throw error;
}

function parseJSON(response) {
  console.log(response);
  return response.json();
}

async function getNutrients(response) {
  console.log(response.list.item);
  const foodArray = response.list.item;

  for (let i = 0; i < foodArray.length; i++) {
    const array = [];
    array.push(
      Promise.all(
        axios
          .get(
            `https://api.nal.usda.gov/ndb/nutrients/?format=json&api_key=c24xU3JZJhbrgnquXUNlyAGXcysBibSmESbE3Nl6&nutrients=208&nutrients=203&nutrients=204&nutrients=205&ndbno=${
              foodArray[i].ndbno
            }`
          )
          .then(checkStatus)
          .then(response => {
            return response.data.report.foods[0];
          })
      )
    );
    console.log(array);
  }
}

const Client = { search };
export default Client;
