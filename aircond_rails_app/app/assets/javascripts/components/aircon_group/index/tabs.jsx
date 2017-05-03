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
        </ul>
      </div>
    )
  }
}

