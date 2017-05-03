class AirconGroupShow extends React.Component {

  render(){
    const { airconGroup } = this.props;
    const { aircons } = airconGroup;
    return(
      <div id="aircon-group-show-container">
        <AirconGroupShowHeader airconGroup={ airconGroup } />
        <AirconGroupShowBody aircons={ aircons } />
      </div>
    )
  }
}
