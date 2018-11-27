import React, { Component } from 'react';

import axios from 'axios';

export default class GetIngredient extends Component {
	constructor(props) {
		super(props);

		this.state = {
			ingredients: []
		};
	}

	getNutrients = () => {
		let req_ndbno = this.state.ingredients.ndbno;

		axios
			.get('https://api.nal.usda.gov/ndb/reports', {
				params: {
					ndbno: { req_ndbno },
					type: 'b',
					format: 'json',
					api_key: 'c24xU3JZJhbrgnquXUNlyAGXcysBibSmESbE3Nl6'
				}
			})
			.then(res => {
				let nutr_Info = res.data;
				console.log(nutr_Info);
				return nutr_Info;
			})
			.catch(err => {
				console.log(err + '\n' + 'statusCode: ', err.status);
			});
	};

	handleSelect = async e => {
		e.preventDefault();
		this.getNutrients()
			.then(axios.post())
			.catch(err => {
				console.log(err + '\n' + 'statusCode: ', err.status);
			});
	};

	componentDidMount = () => {
		axios
			.get('https://api.nal.usda.gov/ndb/search/?', {
				params: {
					q: 'cheese',
					sort: 'n',
					format: 'json',
					api_key: 'c24xU3JZJhbrgnquXUNlyAGXcysBibSmESbE3Nl6'
				}
			})
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
					<li key={ingredient.offset} style={{ textDecoration: 'none' }}>
						<a href="#" style={{ color: '#000' }}>
							{ingredient.name}
						</a>
					</li>
				))}
			</ul>
		);
	}
}
