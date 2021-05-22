import React from 'react';
import PengineClient from './PengineClient';
import Board from './Board';
import ModoOnClick from './ModoOnClick';

class Game extends React.Component {

  pengine;

  constructor(props) {
    super(props);
    this.state = {
      grid: null,
      rowClues: null,
      colClues: null,
      listaFilaSatisfecha: [],
      listaColumnaSatisfecha:[],
      clickActual:"#",
      waiting: false
      
    };
    this.handleClick = this.handleClick.bind(this);
    this.handlePengineCreate = this.handlePengineCreate.bind(this);
    this.pengine = new PengineClient(this.handlePengineCreate);
  }
    
    


  handlePengineCreate() {
    const queryS = 'init(PistasFilas, PistasColumns, Grilla)';
    this.pengine.query(queryS, (success, response) => {
      if (success) {
        this.setState({
          grid: response['Grilla'],
          rowClues: response['PistasFilas'],
          colClues: response['PistasColumns'],
          listaFilaSatisfecha: [...response['PistasFilas']].fill(false),
          listaColumnaSatisfecha:  [...response['PistasColumns']].fill(false)

        });
      }
    });
  }

  handleClick(i, j) {
    // No action on click if we are waiting.
    if (this.state.waiting) {
      return;
    }
    // Build Prolog query to make the move, which will look as follows:
    // put("#",[0,1],[], [],[["X",_,_,_,_],["X",_,"X",_,_],["X",_,_,_,_],["#","#","#",_,_],[_,_,"#","#","#"]], GrillaRes, FilaSat, ColSat)
    const squaresS = JSON.stringify(this.state.grid).replaceAll('"_"', "_"); // Remove quotes for variables.

    const rowCluesProlog = JSON.stringify(this.state.rowClues)
    const colCluesProlog = JSON.stringify(this.state.colClues)

    const queryS = `put("${this.state.clickActual}", [${i},${j}], ${rowCluesProlog}, ${colCluesProlog},${squaresS}, GrillaRes, FilaSat, ColSat)`;
    this.setState({
      waiting: true
    });
    this.pengine.query(queryS, (success, response) => {
      if (success) {
        let satisfaceF = this.state.listaFilaSatisfecha;
        let satisfaceC = this.state.listaColumnaSatisfecha;
        satisfaceF[i] = response['FilaSat'];
        satisfaceC[j]  = response['ColSat'];
        console.log(queryS + " --->> " +JSON.stringify(response))
        this.setState({
          grid: response['GrillaRes'],
          listaFilaSatisfecha: satisfaceF,
          listaColumnaSatisfecha: satisfaceC,
          waiting: false
        });
      } else {
        this.setState({
          waiting: false
        });
      }
    });
  }

    selectX(){
      this.setState({
        clickActual: "X"
      });
    }
    selectPaint(){
      this.setState({
        clickActual: "#"
      });
    }

    terminoJuego(){

      for ( let i of this.state.listaFilaSatisfecha){
        if( i!==1 ) return true;
      }

      for (let i of this.state.listaColumnaSatisfecha){
        if( i!== 1) return true;
      }
     } 
    
     

  render() {

    let statusText = "En juego";

    if (this.state.grid === null) {
      return null;
    }
  
    if (!this.terminoJuego()){
      statusText = "Termino el juego";
    }
    return (
      <div className="game">
        <Board
          grid={this.state.grid}
          rowClues={this.state.rowClues}
          colClues={this.state.colClues}
          listaFilaSatisfecha = {this.state.listaFilaSatisfecha}
          listaColumnaSatisfecha = {this.state.listaColumnaSatisfecha}
          onClick={(i, j) => this.handleClick(i,j)}
        />
        <div className="gameInfo">
          {statusText}
        </div>
        <ModoOnClick
          selectX={()=>this.selectX()}
          selectPaint= {()=>this.selectPaint()}
          />
      </div>
    );
  }
}

export default Game;