import React, { Component } from "react";
import { connect } from "react-redux";
//change the route for this
import { addUser } from "../../store/actions/userActions";
import { withRouter} from "react-router-dom";
// import { Alert } from "reactstrap";
import axios from "axios";
import "./weather.css";

class Weather extends Component {
	constructor(props) {
		super(props);

		this.state = {
            weather: {
                name: "",
                description: "",
                temp:null,
                humidity:null,
                pressure:null

            }
	
		};
    }
    
    componentDidMount() {
        axios.get(`https://api.openweathermap.org/data/2.5/find?q=Bangor&units=imperial&appid=46454cdfa908cad35b14a05756470e5c`)
      .then(response => {
        this.setState({
          weather: response.data.list[0]
    });
        console.log(response.data.list[0]); //returns JSON correctly
        console.log(this.state.weather.main.temp); //returns correct value (304.15)
    })
      .catch(error => {
        console.log('Error', error);
    });
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
            <div className="weather-container">
			    <div className="weather-card">
                    <h1>{this.state.weather.name}</h1>
                    <h1>{this.state.weather.description}</h1>
                    <h1>{this.state.weather.temp}</h1>
                    <h1>{this.state.weather.humidity}</h1>
                    <h1>{this.state.weather.pressure}</h1>
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
)(withRouter(Weather));