import React, { Component } from "react";
import { CardElement, injectStripe } from "react-stripe-elements";

class CheckoutForm extends Component {
  constructor(props) {
    super(props);
    this.state = { complete: false, value: "" };
    this.submit = this.submit.bind(this);
  }

  //   async
  submit(ev) {
    // let { token } = await this.props.stripe.createToken({ name: "Name" });
    // let response = await fetch("/charge", {
    //   method: "POST",
    //   headers: { "Content-Type": "text/plain" },
    //   body: token.id
    if (this.state.value) {
      this.setState({ complete: true });
    } else {
      alert("Please enter valid information");
    }
    // });

    // if (response.ok) this.setState({ complete: true });
  }

  render() {
    if (this.state.complete) return <h1>Success! Welcome to HealHelper</h1>;
    return (
      <div className="checkout">
        <p>Would you like to complete the purchase?</p>
        <span>Name</span>
        <input value={this.state.value} />
        <CardElement />
        <button onClick={this.submit}>Send</button>
      </div>
    );
  }
}

export default injectStripe(CheckoutForm);
