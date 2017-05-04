class AirconGroupIndexTab extends React.Component {
  constructor(props){
    super(props)
    this.switchGroup = this.switchGroup.bind(this)
  }

  switchGroup(){
    const { airconGroup } = this.props
    this.props.switchGroup(airconGroup)
  }

  render(){
    const { airconGroup, active } = this.props
    let activeClass = classNames({ 'active':  active})

    var activeBar;
    if (active) {
      activeBar = ( <div className="pmd-tab-active-bar" style={{width: "100%"}}></div> )
    }

    return(
      <li role="presentation" className={ `${activeClass}` }>
        <a href="#" onClick={ this.switchGroup }>{airconGroup.title}</a>
        { activeBar }
      </li>
    )
  }
}

