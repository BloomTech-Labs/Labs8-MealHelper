import React, { Component } from "react";
import { CardElement, injectStripe } from "react-stripe-elements";
import "./CheckoutForm.css";

class CheckoutForm extends Component {
  constructor(props) {
    super(props);
    this.state = { complete: false, inputValue: "" };
    this.submit = this.submit.bind(this);
  }

  updateInputValue(evt) {
    this.setState({
      inputValue: evt.target.value
    });
  }

  async submit(ev) {
    let { token } = await this.props.stripe.createToken({ name: "Name" });
    let response = await fetch("/charge", {
      method: "POST",
      headers: { "Content-Type": "text/plain" },
      body: token.id
    });

    if (response.ok) this.setState({ complete: true });
  }

  render() {
    if (this.state.complete) return <h1>Success! Welcome to HealHelper</h1>;
    return (
      <div className="checkout">
        <p>Complete Your Purchase</p>
        <label>Name</label>
        <br />
        <input
          className="stripe-name-input"
          value={this.state.inputValue}
          onChange={evt => this.updateInputValue(evt)}
        />
        <CardElement />
        <button onClick={this.submit}>Send</button>
      </div>
    );
  }
}

export default injectStripe(CheckoutForm);
