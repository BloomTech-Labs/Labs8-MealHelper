import React from 'react';

export default class editAlarmModal extends React.Component {
    render() {
        if(!this.props.show) {
            return <h1>test</h1>;
        }
        else {
        return (
            <div className="edit-modal">
                {this.props.children}
            </div>
        )
    }
    }
}
