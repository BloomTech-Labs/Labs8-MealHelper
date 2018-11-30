import React from 'react';

export default class editAlarmModal extends React.Component {
    render() {
        if(this.props.show === false) {
            return null;
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
