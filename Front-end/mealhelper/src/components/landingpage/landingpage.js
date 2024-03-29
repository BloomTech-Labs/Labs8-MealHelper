import React, { Component } from "react";
import { connect } from "react-redux";
import { addUser } from "../../store/actions/userActions";
import { withRouter, Link } from "react-router-dom";

import Computer from "./Computer.png";

import Navbar from "../Navbar/Navbar";
import Recipe from "./Recipes.jpg";

import DoctorPic from "./DoctorPic.png";

import "./landingpage.css";
import "./lp-tablet.css";
import Jumbo from "./jumboIcons2.png";
import Picnic from "./PicnicBlue.jpg";
import Eat from "./eatimage2.png";
import Track from "./trackimage.png";
import Analyze from "./analyzeimage.png";
import EatWell from "./eatwellimage.png";
import Stefano from "../../img/stefano100.jpg";
import Simon from "../../img/simon100.jpg";
import Casey from "../../img/casey100.png";
import Patrick from "../../img/patrick101.png";
import Joseph from "../../img/joseph100.jpg";
import Keith from "../../img/keith100.png";
import Github from "../../img/githublogo.png";
import LinkedIn from "../../img/linkedinlogo.png";

class Landingpage extends Component {
  componentDidMount = () => {
    if (localStorage.getItem("token")) {
      this.props.history.push("/homepage");
    }
  };

  goToSignup = () => {
    this.props.history.push("/signup");
  };
  goToLogin = () => {
    this.props.history.push("/login");
  };

  sendEmail = () => {
    window.open("mailto:lambdafoodapp@gmail.com");
  };

  render() {
    return (
      <div className="main-container">
        <Navbar />
        <a name="home" />
        <div className="landing-page-container">
          <div className="jumbotron-container">
            <img className="jumbotron-img" src={Jumbo} alt="No image" />
          </div>

          <div className="login-signup-container">
            <div className="cta-top-content">
              <div className="cta-container">
                <h2>
                  EAT. <br /> TRACK. <br /> ANALYZE.
                </h2>
              </div>

              <div className="signup-login-buttons-lp">
                <p>
                  Record what you eat and how it makes you feel, and let EatWell
                  help you take the guesswork out of eating well and feeling
                  better.
                </p>
                <Link to="/login" style={{ textDecoration: "none" }}>
                  <button className="buttons-lp">Log In</button>
                </Link>
                <Link to="/signup" style={{ textDecoration: "none" }}>
                  <button className="buttons-lp">Sign Up</button>
                </Link>
              </div>
            </div>
            <div className="cta-bottom-content">
              <div className="real-housewives-quote">
                <a name="product" />
                <p>
                  "Your diet is a bank account. Good food choices are good
                  investments."
                </p>
                <p>-Bethenny Frankel</p>
              </div>
            </div>
          </div>

          <div className="info-container-one">
            <img className="image-info" src={Eat} />
            <div className="card-body-text-container">
              <div className="header-card">
                <p>E A T</p>
              </div>
              <div className="card-body-text">
                <p>
                  EatWell is an advanced meal journal. Each meal can be recorded
                  along with your experience and any notes about positive or
                  negative health events after eating.
                </p>
                <div className="extra">
                  <p className="tip-header">TIP:</p>
                  <p className="tip">
                    Need a reminder? Set alarms for your mobile app at specific
                    times or at regular intervals each day.
                  </p>
                </div>
              </div>
            </div>
          </div>
          <div className="info-container-two">
            <div className="card-body-text-container">
              <div className="header-card">
                <p>T R A C K</p>
              </div>
              <div className="card-body-text">
                <p>
                  EatWell gives you access to a database of thousands of
                  ingredients and pre-packaged food items, so you can build
                  recipes and track nutrients alongside your health events.
                </p>
                <div className="extra">
                  <p className="tip-header">TIP:</p>
                  <p className="tip">
                    Weather got you gloomy? Add your zip code to get access to
                    local weather information during each meal.
                  </p>
                </div>
              </div>
            </div>
            <img className="image-info" src={Track} />
          </div>
          <div className="info-container-three">
            <img className="image-info" src={Analyze} />
            <div className="card-body-text-container">
              <div className="header-card">
                <p>A N A L Y Z E</p>
              </div>
              <div className="card-body-text">
                <p>
                  Export an overview of your meal journal to show to a health
                  professional, or view your history to pick up clues yourself!
                </p>
                <div className="extra">
                  <p className="tip-header">TIP:</p>
                  <p className="tip">
                    Purchase the premium version for access to unlimited meals
                    and recipe storage for a better look at long-term trends.
                  </p>
                </div>
              </div>
            </div>
          </div>
          <div className="info-container-four">
            <div className="card-body-text-container">
              <div className="header-card">
                <p>E A T W E L L</p>
              </div>
              <div className="card-body-text">
                <p>
                  Repeat! Newly empowered with a better understanding of how
                  what you eat correlates with how you feel, continue using
                  EatWell as you make adjustments to your diet and fine tune a
                  nutritional plan that works for YOU!
                </p>
                <div className="mini-cta">
                  <Link to="/signup" style={{ textDecoration: "none" }}>
                    <button className="buttons-lp">Get Started</button>
                  </Link>
                </div>
              </div>
            </div>
            <img className="image-info" src={EatWell} />
          </div>
        </div>
        <a name="pricing" />
        <div className="pricing">
          <h1>Pricing</h1>
          <div className="charts" id="price">
            <div className="plan">
              <div className="plan-inner">
                <div className="entry-title">
                  <h3>Free</h3>
                  <div className="price">
                    $0<span>/PER USER</span>
                  </div>
                </div>
                <div className="entry-content">
                  <ul>
                    <li>
                      Make up to <strong>50</strong> meals
                    </li>
                    <li>
                      Make up to <strong>100</strong> recipes
                    </li>
                    <li>
                      Make up to <strong>5</strong> alarms
                    </li>
                  </ul>
                </div>
                <div className="free-btn">
                  <a href="#">Free</a>
                </div>
              </div>
            </div>
            <div className="plan basic">
              <div className="plan-inner">
                <div className="hot">hot!</div>
                <div className="entry-title">
                  <h3>Premium</h3>
                  <div className="price">
                    $4.99<span>/PER USER</span>
                  </div>
                </div>
                <div className="entry-content-premium">
                  <ul>
                    <li>
                      Make <strong>unlimited</strong> meals
                    </li>
                    <li>
                      Make <strong>unlimited</strong> recipes
                    </li>
                    <li>
                      Make <strong>unlimited</strong> alarms
                    </li>
                    <li>
                      Get a <strong>warm</strong> fuzzy feeling
                    </li>
                  </ul>
                </div>
                <div className="btn">
                  <a href="#">Buy Now</a>
                </div>
              </div>
            </div>
          </div>
        </div>

        <a name="team" />
        <div className="team-section-container">
          <div className="Team">
            <h1>Team</h1>
            <div className="team-cards">
              <div className="team-column">
                <div className="card">
                  <img
                    src={Keith}
                    alt="Team Member"
                    className="team-member"
                    style={{ width: 85 }}
                  />
                  <div className="team-container">
                    <h2>Keith Haag</h2>
                    <p className="title">Project Manager</p>
                    <p>Some text that describes me lorem ipsum ipsum lorem.</p>
                    <a href="https://github.com/kkhaag">
                      <img
                        src={Github}
                        alt="Github"
                        className="Github"
                        style={{ width: 20 }}
                      />
                    </a>
                    <a href="https://www.linkedin.com/in/k-haag-02a45190/">
                      <img
                        src={LinkedIn}
                        alt="LinkedIn"
                        className="linkedin"
                        style={{ width: 30 }}
                      />
                    </a>
                    <p>
                      <button
                        className="contact-button"
                        onClick={this.sendEmail}
                      >
                        Contact
                      </button>
                    </p>
                  </div>
                </div>
              </div>
              <div className="team-column">
                <div className="card">
                  <img
                    src={Simon}
                    alt="Key Team Member"
                    className="team-member"
                    style={{ width: 100 }}
                  />
                  <div className="team-container">
                    <h2>Simon Elhøj Steinmejer</h2>
                    <p className="title">iOS Developer</p>
                    <p>Some text that describes me lorem ipsum ipsum lorem.</p>
                    <a href="https://github.com/elhoej">
                      <img
                        src={Github}
                        alt="Github"
                        className="Github"
                        style={{ width: 20 }}
                      />
                    </a>
                    <a href="https://www.linkedin.com/in/simon-elh%C3%B8j-steinmejer-36752ba2/">
                      <img
                        src={LinkedIn}
                        alt="LinkedIn"
                        className="linkedin"
                        style={{ width: 30 }}
                      />
                    </a>
                    <p>
                      <button
                        className="contact-button"
                        onClick={this.sendEmail}
                      >
                        Contact
                      </button>
                    </p>
                  </div>
                </div>
              </div>
              <div className="team-column">
                <div className="card">
                  <img
                    src={Stefano}
                    alt="Key Team Member"
                    className="team-member"
                    style={{ width: 100 }}
                  />
                  <div className="team-container">
                    <h2>Stefano De Micheli</h2>
                    <p className="title">iOS Developer</p>
                    <p>Some text that describes me lorem ipsum ipsum lorem.</p>
                    <a href="https://github.com/stdemicheli">
                      <img
                        src={Github}
                        alt="Github"
                        className="Github"
                        style={{ width: 20 }}
                      />
                    </a>
                    <a href="https://www.linkedin.com/in/stefano-demicheli/">
                      <img
                        src={LinkedIn}
                        alt="LinkedIn"
                        className="linkedin"
                        style={{ width: 30 }}
                      />
                    </a>
                    <p>
                      <button
                        className="contact-button"
                        onClick={this.sendEmail}
                      >
                        Contact
                      </button>
                    </p>
                  </div>
                </div>
              </div>
              <div className="team-column">
                <div className="card">
                  <img
                    src={Casey}
                    alt="Team Member"
                    className="team-member"
                    style={{ width: 100 }}
                  />
                  <div className="team-container">
                    <h2>Casey Baker</h2>
                    <p className="title">Web Developer</p>
                    <p>Some text that describes me lorem ipsum ipsum lorem.</p>
                    <a href="https://github.com/abravebee">
                      <img
                        src={Github}
                        alt="Github"
                        className="Github"
                        style={{ width: 20 }}
                      />
                    </a>
                    <a href="https://www.linkedin.com/in/casey-baker-a52a30167/">
                      <img
                        src={LinkedIn}
                        alt="LinkedIn"
                        className="linkedin"
                        style={{ width: 30 }}
                      />
                    </a>
                    <p>
                      <button
                        className="contact-button"
                        onClick={this.sendEmail}
                      >
                        Contact
                      </button>
                    </p>
                  </div>
                </div>
              </div>
              <div className="team-column">
                <div className="card">
                  <img
                    src={Joseph}
                    alt="Team Member"
                    className="team-member"
                    style={{ width: 106 }}
                  />
                  <div className="team-container">
                    <h2>Joseph Bradley</h2>
                    <p className="title">Web Developer</p>
                    <p>Some text that describes me lorem ipsum ipsum lorem.</p>
                    <a href="https://github.com/jmbradley">
                      <img
                        src={Github}
                        alt="Github"
                        className="Github"
                        style={{ width: 20 }}
                      />
                    </a>
                    <a href="https://www.linkedin.com/in/joseph-m-bradley-7861baa/">
                      <img
                        src={LinkedIn}
                        alt="LinkedIn"
                        className="linkedin"
                        style={{ width: 30 }}
                      />
                    </a>
                    <p>
                      <button
                        className="contact-button"
                        onClick={this.sendEmail}
                      >
                        Contact
                      </button>
                    </p>
                  </div>
                </div>
              </div>
              <div className="team-column">
                <div className="card">
                  <img
                    src={Patrick}
                    alt="Team Member"
                    className="team-member"
                    style={{ width: 88 }}
                  />
                  <div className="team-container">
                    <h2>Patrick Thompson</h2>
                    <p className="title">Web Devloper</p>
                    <p>Some text that describes me lorem ipsum ipsum lorem.</p>
                    <a href="https://www.github.com/PatrickTheCodeGuy">
                      <img
                        src={Github}
                        alt="Github"
                        className="Github"
                        style={{ width: 20 }}
                      />
                    </a>
                    <a href="https://www.linkedin.com/patrick-thompson-the-code-guy">
                      <img
                        src={LinkedIn}
                        alt="LinkedIn"
                        className="linkedin"
                        style={{ width: 30 }}
                      />
                    </a>
                    <p>
                      <button
                        className="contact-button"
                        onClick={this.sendEmail}
                      >
                        Contact
                      </button>
                    </p>
                  </div>
                </div>
              </div>
            </div>
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
