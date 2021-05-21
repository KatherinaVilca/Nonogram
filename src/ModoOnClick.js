import React from 'react';

class ModoOnClick extends React.Component{

    render(){
        return(
            <div>
                <button className="X" onClick={this.props.selectX}>
                X
                </button>

                <button className="#" onClick={this.props.selectPaint}>
                #
                </button>
            </div>
               
           
        );
    }   
}
export default ModoOnClick;