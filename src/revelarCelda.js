import React from 'react';

class revelarCelda extends React.Component{

    render(){
        return(

                <button className="Revelar" onClick={this.props.RevelarCelda}>
                ?
                </button>  

        );
    }   
}
export default revelarCelda;