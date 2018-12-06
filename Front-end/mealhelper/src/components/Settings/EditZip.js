import React, { Component } from "react";
import axios from "axios";
import { connect } from "react-redux";
import "../homepage/homepage";
//change the route for this
import { addUser } from "../../store/actions/userActions";
import { withRouter, Link, Route, Switch } from "react-router-dom";
import { Alert } from "reactstrap";
import { Button, Modal, ModalHeader } from "reactstrap";

class EditZip extends Component {
  constructor(props) {
    super(props);

    this.state = {
      user: [],
      updated: false,
      visablePassword: false,
      zip: null,
      password: "",
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

  handleChange = event => {
    event.preventDefault();
    this.setState({
      [event.target.name]: event.target.value
    });
  };
  toggleVisability = () => {
    this.setState({ visable: false, visablePassword: false });
  };
  goHome = () => {
    if (this.state.updated === true) {
      this.props.history.push("/homepage");
    } else {
      alert("Error updating settins. Our server may be down.");
    }
  };
  async confirmChange() {
    const confirmed = await this.changeZip();
    setTimeout(this.goHome, 8000);
  }
  changeZip = event => {
    if (!this.state.zip || !this.state.password) {
      this.setState({ visable: true });
      setTimeout(this.toggleVisability, 3000);
    } else {
      const id = localStorage.getItem("user_id");
      const { zip, password } = this.state;
      const user = { zip, password };
      axios
        .put(`https://labs8-meal-helper.herokuapp.com/users/zip/${id}`, user)
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
            Please enter your old password, a new password and confirm your new
            password.
          </Alert>
        </div>
        <div className="alert-box2">
          <Alert isOpen={this.state.visablePassword} color="danger">
            New passwords do not match, try again.
          </Alert>
        </div>
        <div className="alert-box-settings">
          <Alert isOpen={this.state.updated} color="primary">
            Settings have been updated! Please wait while you are redirected...
          </Alert>
        </div>
        <div className="settings-text">
          <h1>Change Zip</h1>
        </div>
        <div className="settings-zip-form">
          <form>
            <div>
              <h5>Zip</h5>
              <input
                type="number"
                name="zip"
                onChange={this.handleChange}
                value={this.state.zip}
                placeholder="Enter New Zip . . ."
              />
            </div>
            <div>
              <h5>Password</h5>
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
          Save Zip
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
)(withRouter(EditZip));
