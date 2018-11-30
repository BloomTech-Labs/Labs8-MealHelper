import React, { Component } from "react";
import { connect } from "react-redux";
import Typing from "react-typing-animation";
//change the route for this
import { addUser } from "../../store/actions/userActions";
import { withRouter, Link, Route } from "react-router-dom";
// import { Alert } from "reactstrap";
import Sign2 from "../../components/Sign2";
import Callback from "../../Callback";
import "./landingpage.css";

class Landingpage extends Component {
  constructor(props) {
    super(props);

    this.state = {
      email: "",
      password: "",
      zip: null,
      healthCondition: "",
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
      <div className="main-container">
        <div className="entry-button-group">
          <Link to="/signup">
            <button className="signup-button">
              <span>Signup</span>
            </button>
          </Link>
          <Link to="/login">
            <button className="signup-button">
              <span>Login</span>
            </button>
          </Link>
          <div>
            <Sign2 />
            <Route exact path="/callback" component={Callback} />
          </div>
        </div>
        <div className="landpage-content">
          <Typing className="typing " speed={90}>
            <span>Welcome to Meal4U "(not the actual name)"</span>
          </Typing>
          <br />
          <br />
          <br />
          <h2>
            Meal4U is a meal tracking app that is meant to help those with
            health needs track and manage their meals.
          </h2>
          <h2>This app can: </h2>
          <div className="checklist">
            <h3>* Remind them to eat</h3>
            <h3>* Track what they eat</h3>
            <h3>* Save recipes and/or ingredients</h3>
            <h3>* Track what happens after a meal</h3>
            <h3>* Record the weather during a meal</h3>
            <h3>* Export the above into a single PDF</h3>
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
)(withRouter(Landingpage));
