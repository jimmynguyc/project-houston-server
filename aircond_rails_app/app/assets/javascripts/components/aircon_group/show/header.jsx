class AirconGroupShowHeader extends React.Component {
  render(){
    const { airconGroup } = this.props

    return(
      <div id="aircon-group-show-header">
        { airconGroup.title }
      </div>
    )
  }
}

