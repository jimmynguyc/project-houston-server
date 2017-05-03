class AirconGroupShow extends React.Component {

  render(){
    const { aircon_group } = this.props;
    const { airconds } = aircon_group;

    return(
      <div id="aircon-group-show-container">
        <AirconGroupShowHeader airconGroup={ aircon_group } />
        <AirconGroupShowBody aircons={ airconds } />
      </div>
    )
  }
}
