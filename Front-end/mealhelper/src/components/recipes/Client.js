/* eslint-disable no-undef */
async function search(query, cb) {
  return fetch(
    `https://api.nal.usda.gov/ndb/search/?format=json&It=f&q=${query}&sort=n&max=100&offset=0&api_key=c24xU3JZJhbrgnquXUNlyAGXcysBibSmESbE3Nl6`,
    {
      accept: "application/json"
    }
  )
    .then(checkStatus)
    .then(await parseJSON)
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

const Client = { search };
export default Client;
