import React from 'react';

export default class Modal extends React.Component {
    render() {
        if(!this.props.show) {
            return null;
        }
        return (
            <div className="edit-modal">
            <h1>in updateAlarm</h1>
                {this.props.children}
            </div>
        )
    }
}
