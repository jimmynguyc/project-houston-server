class AirconGroupIndex extends React.Component {
  constructor(props) {
    super(props)

    const { airconGroups } = this.props
    const currentGroup = airconGroups[0]

    this.state = {
      currentGroup: currentGroup
    }

    this.switchGroup = this.switchGroup.bind(this)
  }

  switchGroup(group){
    this.setState({currentGroup: group})
  }

  render(){
    const { airconGroups } = this.props;
    const { currentGroup } = this.state;

    return(
      <div id="aircon-group-index-container">
        <div className="row">
          <div className="col-xs-12">
            <AirconGroupIndexTabs airconGroups={ airconGroups } currentGroup={ currentGroup } switchGroup={ this.switchGroup } />
          </div>
        </div>
        <div className="row">
          <div className="col-xs-12">
            <AirconGroupShow airconGroup={ currentGroup } />
          </div>
        </div>
      </div>
    )
  }
}

