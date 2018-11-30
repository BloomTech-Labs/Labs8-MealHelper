import React from "react";
import { withRouter } from "react-router-dom";
import auth0Client from "../Auth";
// import Facelogo from "../img/facebook.png";
import Googlogo from "../img/google.png";

import "./Sign.css";

function Sign2(props) {
  const signOut = () => {
    auth0Client.signOut();
    props.history.replace("/");
  };

  return (
    <nav className="nah">
      {!auth0Client.isAuthenticated() && (
        <button className="authlogos2" onClick={auth0Client.signIn}>
          <p className="login-with">Login</p>
          <p className="login-with-2">With</p>
          <img src={Googlogo} className="authlogo2" alt="Google" />
        </button>
      )}
      {auth0Client.isAuthenticated() && (
        <div>
          <label className="mr-2 text-black">
            {auth0Client.getProfile().name}
          </label>
          <button
            className="btn btn-dark"
            onClick={() => {
              signOut();
            }}
          >
            Sign Out
          </button>
        </div>
      )}
    </nav>
  );
}

export default withRouter(Sign2);
