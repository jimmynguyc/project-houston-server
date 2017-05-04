class AirconGroupIndexTabs extends React.Component {
  constructor(props){
    super(props)
    this.switchGroup = this.switchGroup.bind(this)
  }

  switchGroup(group){
    this.props.switchGroup(group)
  }

  render(){
    const { airconGroups, currentGroup } = this.props
    return(
      <div id="aircon-group-index-tabs" className="pmd-tabs pmd-tabs-bg">
        <ul className="nav nav-tabs" role="tablist">
          {
            airconGroups.map((airconGroup) => {
              const active = airconGroup.id === currentGroup.id
              return(
                <AirconGroupIndexTab
                  airconGroup={airconGroup}
                  switchGroup={this.switchGroup}
                  active={ active }
                  key={`tab-${airconGroup.id}`}
                />)
            })
          }
          <li role="presentation" className="pull-right">
            <a href="/airconds/new">Add Aircon</a>
          </li>
          <li role="presentation" className="pull-right">
            <a href="#">Mobile Apps</a>
          </li>
        </ul>
      </div>
    )
  }
}

