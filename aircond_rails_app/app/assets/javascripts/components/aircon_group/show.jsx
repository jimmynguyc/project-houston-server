class AirconGroupShow extends React.Component {

  render(){
    const { airconGroup } = this.props;
    const { airconds } = airconGroup;

    return(
      <div id="aircon-group-show-container">
        <AirconGroupShowHeader airconGroup={ airconGroup } />
        <AirconGroupShowBody aircons={ airconds } />
      </div>
    )
  }
}
