/* eslint-disable no-undef */
async function search(query, cb) {
	return (
		fetch(
			`https://api.nal.usda.gov/ndb/search/?format=json&q=${query}&sort=n&max=10&offset=0&api_key=c24xU3JZJhbrgnquXUNlyAGXcysBibSmESbE3Nl6`,
			{
				accept: "application/json"
			}
		)
			.then(checkStatus)
			.then(await parseJSON)
			// .then(getNutrients)
			.then(cb)
	);
}

// async function getNutrients(response) {
// 	let result = await thisShouldFinish(response);
// 	function thisShouldFinish(response) {
// 		let req_ndbno = response.list.item.map(item => {
// 			return item.ndbno;
// 		});
// 		console.log(req_ndbno);
// 		let nutrientsArray = [];
// 		req_ndbno.map((nutrient_ids, index) => {
// 			fetch(
// 				`https://api.nal.usda.gov/ndb/nutrients/?format=json&api_key=c24xU3JZJhbrgnquXUNlyAGXcysBibSmESbE3Nl6&nutrients=203&nutrients=204&nutrients=205&ndbno=${nutrient_ids}`
// 			)
// 				.then(function(response) {
// 					return response.json();
// 				})
// 				.then(function(json) {
// 					console.log(json.report.foods[0]);
// 					nutrientsArray.push(json.report.foods[0]);
// 					// nutrientsArray.push(json.report.foods[0].nutrients);
// 					response.list.item[index] = nutrientsArray[index];
// 					// response.list.item[index]["nutrients"] = nutrientsArray[index];
// 				});
// 		});
// 		console.log(response);
// 	}

// 	return result;
// }

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
