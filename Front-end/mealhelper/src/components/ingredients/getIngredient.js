import React, { Component } from 'react';

import axios from 'axios';

export default class GetIngredient extends Component {
	constructor(props) {
		super(props);

		this.state = {
			list: [],
			search: '',
			name: '',
			ndbno: null
		};
	}

	// getNutrients = () => {
	// 	let req_ndbno = this.state.ingredients.ndbno;

	// 	axios
	// 		.get('https://api.nal.usda.gov/ndb/reports', {
	// 			params: {
	// 				ndbno: { req_ndbno },
	// 				type: 'b',
	// 				format: 'json',
	// 				api_key: 'c24xU3JZJhbrgnquXUNlyAGXcysBibSmESbE3Nl6'
	// 			}
	// 		})
	// 		.then(res => {
	// 			let nutr_Info = res.data;
	// 			console.log(nutr_Info);
	// 			return nutr_Info;
	// 		})
	// 		.catch(err => {
	// 			console.log(err + '\n' + 'statusCode: ', err.status);
	// 		});
	// };

	searchFood = event => {
		event.preventDefault();
		axios
			.get(
				`https://api.nal.usda.gov/ndb/search/?format=json&q=${
					this.state.search
				}&sort=n&max=25&offset=0&api_key=c24xU3JZJhbrgnquXUNlyAGXcysBibSmESbE3Nl6`
			)
			.then(response => {
				console.log(response);
				this.setState({
					list: response.data.list.item
				});
			})
			.catch(error => {
				console.log('Error', error);
			});
	};

	handleSelect = async e => {
		e.preventDefault();
		this.getNutrients();
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
			<div>
				<button onClick={this.searchFood}>Search</button>
				<ul>
					{this.state.ingredients.map(ingredient => (
						<li key={ingredient.offset} style={{ textDecoration: 'none' }}>
							<a href="#" style={{ color: '#000' }}>
								{ingredient.name}
							</a>
						</li>
					))}
				</ul>
			</div>
		);
	}
}
