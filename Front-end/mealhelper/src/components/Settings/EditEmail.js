import React, { Component } from "react";
import axios from "axios";
import { connect } from "react-redux";
import "../homepage/homepage";
//change the route for this
import { addUser } from "../../store/actions/userActions";
import { withRouter, Link } from "react-router-dom";
import { Alert } from "reactstrap";

class EditEmail extends Component {
  constructor(props) {
    super(props);

    this.state = {
      user: [],
      updated: false,
      email: "",
      password: "",
      zip: null,
      healthCondition: "",
      visable: false,
      modal: false
    };
    this.confirmChange = this.confirmChange.bind(this);
  }

  componentDidMount = () => {
    const id = localStorage.getItem("user_id");
    axios
      .get(`https://labs8-meal-helper.herokuapp.com/users/${id}`)
      .then(user => {
        this.setState({ user: user.data });
      })
      .catch(err => {
        console.log(err);
      });
  };
  goHome = () => {
    if (this.state.updated === true) {
      this.props.history.push("/homepage");
    } else {
      alert("Error updating settins. Our server may be down.");
    }
  };
  async confirmChange() {
    const confirmed = await this.changeEmail();
    setTimeout(this.goHome, 8000);
  }
  handleChange = event => {
    event.preventDefault();
    this.setState({
      [event.target.name]: event.target.value
    });
  };
  toggleVisability = () => {
    this.setState({ visable: false });
  };

  changeEmail = event => {
    if (!this.state.email || !this.state.password) {
      this.setState({ visable: true });
      setTimeout(this.toggleVisability, 3000);
    } else {
      const id = localStorage.getItem("user_id");
      const { email, password } = this.state;
      const user = { email, password };
      axios
        .put(`https://labs8-meal-helper.herokuapp.com/users/email/${id}`, user)
        .then(response => {
          console.log(response);
          this.setState({ updated: true });
        });
      // this.props.history.push("/");
    }
  };

  toggle = () => {
    this.setState({
      modal: !this.state.modal
    });
  };

  logout = event => {
    event.preventDefault();
    localStorage.removeItem("token");
    localStorage.removeItem("user_id");
    this.props.history.push("/");
  };

  render() {
    return (
      <div className="Settings-Zip-Container">
        <div className="alert-box2">
          <Alert isOpen={this.state.visable} color="danger">
            Please enter an email and password.
          </Alert>
        </div>
        <div className="alert-box-settings">
          <Alert isOpen={this.state.updated} color="primary">
            Settings have been updated! Please wait while you are redirected...
          </Alert>
        </div>
        <div className="settings-text">
          <h1>Change Email</h1>
        </div>
        <Link to="/homepage/settings">
          <p className="settings-text-back-to-settings">Back to settings</p>
        </Link>
        <div className="settings-zip-form">
          <form>
            <div>
              <h5 className="settings-text-anchor">New Email</h5>
              <input
                type="text"
                name="email"
                onChange={this.handleChange}
                value={this.state.email}
                placeholder="Enter New Email . . ."
              />
            </div>
            <div>
              <h5 className="settings-text-anchor">Password</h5>
              <input
                type="password"
                name="password"
                onChange={this.handleChange}
                value={this.state.password}
                placeholder="Enter Password . . ."
              />
            </div>
          </form>
        </div>
        <button onClick={this.confirmChange} className="settings-zip-save">
          Save Email
        </button>
      </div>
    );
  }
}

const mapStateToProps = state => ({
  user: state.userReducer.user
});

export default connect(
  mapStateToProps,
  { addUser }
)(withRouter(EditEmail));
