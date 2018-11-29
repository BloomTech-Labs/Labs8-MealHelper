<Navbar color="faded hide-nav" light>
	<NavbarBrand href="/" className="mr-auto">
		mealhelper
	</NavbarBrand>
	<NavbarToggler onClick={this.toggleNavbar} className="mr-2" />
	<Collapse isOpen={!this.state.collapsed} navbar>
		<Nav navbar>
			<NavItem style={{ textDecoration: 'none' }}>
				<NavLink href="/homepage/recipes">Recipes</NavLink>
			</NavItem>
			<NavItem style={{ textDecoration: 'none' }}>
				<NavLink href="/homepage/alarms">Alarms</NavLink>
			</NavItem>
			<NavItem style={{ textDecoration: 'none' }}>
				<NavLink href="/homepage/meals">Meals</NavLink>
			</NavItem>
			<NavItem style={{ textDecoration: 'none' }}>
				<NavLink href="/homepage/billing">Billing</NavLink>
			</NavItem>
			<NavItem style={{ textDecoration: 'none' }}>
				<NavLink href="/homepage/settings">Settings</NavLink>
			</NavItem>
		</Nav>
	</Collapse>
</Navbar>;
