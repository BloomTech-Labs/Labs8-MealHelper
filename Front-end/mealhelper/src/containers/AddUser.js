import React from 'react';
import { connect } from 'react-redux';
// import { addUser } from  '../store/actions/userActions';

const AddUser = ({ dispatch }) => {
    return (
        <div>
            <form onSubmit={e => {
                e.preventDefault();
                if (!input.value.trim()) {
                    return
                }
                dispatch(addUser(input.value))
                input.value='';
            }}>
                <div className="form-group">
                    <input type="text" id="dynamic-label-input" placeholder="Email" ref ={node => input = node}/>
                    <label htmlFor="dynamic-label-input">Email</label>
                </div>
                <div className="form-group">
                    <input type="password" id="dynamic-label-input" placeholder="Password" ref ={node => input = node} />
                    <label htmlFor="dynamic-label-input">Password</label>
                </div>
                <div className="login login-two" onClick= { onClick }>
                    <span>Login</span>
                </div>
            </form>
                })
            }}
        </div>
    )
}

