import React, { Component } from 'react';

import axios from 'axios';

export default class GetIngredient extends Component {
	state = {
		ingredients: []
	};

	componentDidMount = () => {
		axios
			.get(
				'https://api.nal.usda.gov/ndb/search/?q=cheese&sort=n&format=json&api_key=c24xU3JZJhbrgnquXUNlyAGXcysBibSmESbE3Nl6'
			)
			.then(response => {
				const ingredient = response.data.list.item;
				this.setState({ ingredients: ingredient });
				console.log(ingredient);
			})
			.catch(err => {
				console.log(err + '\n' + 'statusCode: ', err.status);
			});
	};

	render() {
		return (
			<ul>
				{this.state.ingredients.map(ingredient => (
					<li key={ingredient.offset}>{ingredient.name}</li>
				))}
			</ul>
		);
	}
}
