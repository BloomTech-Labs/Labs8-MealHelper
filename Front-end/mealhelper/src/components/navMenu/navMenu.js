import React, { Component } from 'react';
import { Collapse, Navbar, NavbarToggler, NavbarBrand, Nav, NavItem, NavLink } from 'reactstrap';

import './navMenu.css';

export default class NavMenu extends Component {
	constructor(props) {
		super(props);

		this.state = {
			collapsed: true
		};
	}

	toggleNavbar = () => {
		this.setState({
			collapsed: !this.state.collapsed
		});
	};

	render() {
		return (
			<div className="hb-container">
				<Navbar>
					<NavbarBrand href="/homepage" className="mr-auto">
						<h3 className="titlelinks">MealHelper</h3>
					</NavbarBrand>
					<NavbarToggler onClick={this.toggleNavbar} className="mr-2">
						<div className="hb-btn">
							<div />
							<div />
							<div />
						</div>
					</NavbarToggler>
					<Collapse isOpen={!this.state.collapsed} navbar>
						<Nav navbar>
							<NavItem style={{ textDecoration: 'none' }}>
								<NavLink href="/homepage/recipes">
									<h4 className="titlelinks">Recipes</h4>
								</NavLink>
							</NavItem>
							<NavItem style={{ textDecoration: 'none' }}>
								<NavLink href="/homepage/alarms">
									<h4 className="titlelinks">Alarms</h4>
								</NavLink>
							</NavItem>
							<NavItem style={{ textDecoration: 'none' }}>
								<NavLink href="/homepage/meals">
									<h4 className="titlelinks">Meals</h4>
								</NavLink>
							</NavItem>
							<NavItem style={{ textDecoration: 'none' }}>
								<NavLink href="/homepage/billing">
									<h4 className="titlelinks">Billing</h4>
								</NavLink>
							</NavItem>
							<NavItem style={{ textDecoration: 'none' }}>
								<NavLink href="/homepage/settings">
									<h4 className="titlelinks">Settings</h4>
								</NavLink>
							</NavItem>
						</Nav>
					</Collapse>
				</Navbar>
			</div>
		);
	}
}
