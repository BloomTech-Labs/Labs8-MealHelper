import React from 'react';

import axios from 'axios';

export default class getIngredient extends React {
	state = {
		ingredients: []
	};

	componentDidMount = () => {
		axios({
			method: 'GET',
			url: 'https://api.nal.usda.gov/ndb/reports?',
			data: {
				q: 'cheese',
				sort: 'n',
				format: JSON,
				api_key: process.env.NDB_API_KEY
			}
		})
			.then(res => {
				const ingredients = res.data;
				this.setState({ ingredients });
			})
			.catch(err => {
				console.log('error: ', err);
			});
	};

	render() {
		return (
			<ul>
				{this.state.ingredients.map(ingredient => (
					<li>{ingredient.item}</li>
				))}
			</ul>
		);
	}
}
