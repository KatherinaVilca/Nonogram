import React from 'react';

class Square extends React.Component {
    render() {
        let pintar= this.props.value==="#" ? " pintar": "square"
        return (
            <button className={"square"+pintar } onClick={this.props.onClick}>
                {this.props.value !== '_' ? this.props.value : null}
            </button>
        );
    }
}

export default Square;