import React, { Component } from 'react';
import { connect } from 'react-redux';
import './homepage.css';
//change the route for this
import { addUser } from '../../store/actions/userActions';
import { withRouter, Link, Route, Switch } from 'react-router-dom';
import { Alert } from 'reactstrap';
import Weather from '../weather/weather';
import Recipes from '../recipes/recipes';
import Meals from '../Meals/Meals';
import CreateNewRecipe from '../creatnewrecipe/createnewrecipe';
import NavMenu from '../navMenu/navMenu';

class HomePage extends Component {
	constructor(props) {
		super(props);

		this.state = {
			email: '',
			password: '',
			zip: null,
			healthCondition: '',
			visable: false
		};
	}

	handleChange = event => {
		event.preventDefault();
		this.setState({
			[event.target.name]: event.target.value
		});
	};

	createUser = event => {
		event.preventDefault();
		if (!this.state.email || !this.state.password) {
			this.setState({ visable: true });
		} else {
			const { email, password, zip, healthCondition } = this.state;
			const user = { email, password, zip, healthCondition };
			this.props.addUser(user);
			// this.props.history.push("/");
		}
	};

	render() {
		return (
			<div>
				<div className="home-container">
					<NavMenu className="hide-nav" />
					<div className="sidebar">
						<Link to="/homepage/recipes" style={{ textDecoration: 'none' }}>
							<h2 className="titlelinks">Recipes</h2>
						</Link>
						<Link to="/homepage/alarms" style={{ textDecoration: 'none' }}>
							<h2 className="titlelinks">Alarms</h2>
						</Link>
						<Link to="/homepage/meals" style={{ textDecoration: 'none' }}>
							<h2 className="titlelinks">Meals</h2>
						</Link>
						<Link to="/homepage/billing" style={{ textDecoration: 'none' }}>
							<h2 className="titlelinks">Billing</h2>
						</Link>
						<Link to="/homepage/settings" style={{ textDecoration: 'none' }}>
							<h2 className="titlelinks">Settings</h2>
						</Link>
					</div>
					<div className="dynamic-display">
						<Switch>
							<Route path="/homepage/weather" render={() => <Weather />} />
							<Route exact path="/homepage/recipes" render={() => <Recipes />} />
							<Route exact path="/homepage/meals" render={() => <Meals />} />
							<Route path="/homepage/recipes/createnewrecipe" render={() => <CreateNewRecipe />} />
							{/* <Route path="/homepage/alarms" render={() => <Alarms />} />
							<Route path="/homepage/billing" render={() => <Billing />} />
			                <Route path="/homepage/settings" render={() => <Settings />} /> */}
						</Switch>
					</div>
				</div>
			</div>
		);
	}
}

const mapStateToProps = state => ({
	user: state.user
});

export default connect(
	mapStateToProps,
	{ addUser }
)(withRouter(HomePage));
