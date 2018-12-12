import React, { Component } from "react";
import axios from "axios";
import { connect } from "react-redux";
import "../homepage/homepage";
//change the route for this
import { addUser } from "../../store/actions/userActions";
import { withRouter } from "react-router-dom";
import { Alert } from "reactstrap";

class EditPassword extends Component {
  constructor(props) {
    super(props);

    this.state = {
      user: [],
      updated: false,
      visablePassword: false,
      oldpassword: "",
      newpassword: "",
      confirmpassword: "",
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
    const confirmed = await this.changePassword();
    setTimeout(this.goHome, 8000);
  }
  changePassword = event => {
    if (!this.state.oldpassword) {
      this.setState({ visable: true });
      setTimeout(this.toggleVisability, 3000);
    }
    if (
      this.state.newpassword !== this.state.confirmpassword ||
      this.state.newpassword === "New Password" ||
      this.state.newpassword === ""
    ) {
      console.log(this.state.newpassword);
      this.setState({ visablePassword: true });
      setTimeout(this.toggleVisability, 3000);
    } else {
      const id = localStorage.getItem("user_id");
      const { oldpassword, newpassword } = this.state;
      const user = { oldpassword, newpassword };
      axios
        .put(
          `https://labs8-meal-helper.herokuapp.com/users/password/${id}`,
          user
        )
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
      <div className="Settings-Options-Container">
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
        <div className="alert-box2">
          <Alert isOpen={this.state.updated} color="success">
            Settings have been updated! Please wait while you are redirected...
          </Alert>
        </div>
        <div className="settings-text">
          <h1>Change Password</h1>
        </div>
        <div className="settings-password-form">
          <form>
            <div>
              <h5 className="settings-text-anchor">Old Password</h5>
              <input
                type="password"
                name="oldpassword"
                onChange={this.handleChange}
                value={this.state.oldpassword}
                placeholder="Enter Old Password . . ."
              />
            </div>
            <div>
              <h5 className="settings-text-anchor">New Password</h5>
              <input
                type="password"
                name="newpassword"
                onChange={this.handleChange}
                value={this.state.newpassword}
                placeholder="Enter New Password . . ."
              />
            </div>
          </form>
        </div>
        <button onClick={this.confirmChange} className="settings-password-save">
          Save Password
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
)(withRouter(EditPassword));
