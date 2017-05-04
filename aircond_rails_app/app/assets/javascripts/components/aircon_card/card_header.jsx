class CardHeader extends React.Component {
  constructor(props) {
    super(props)
    this.togglePower = this.togglePower.bind(this)
  }

  togglePower() {
    this.props.powerToggleHandler(!this.props.power)
  }

  render() {
    const switchId = "onoffswitch-" + this.props.title

    return (
      <div className="pmd-card-media card-header">
        <div className="media-body card-header-title">
          <h2 className="pmd-card-title-text">{this.props.title}</h2>
          <span className="pmd-card-subtitle-text">AG-1-111</span>
        </div>

        <div className="media-right media-middle">
          <div className="onoffswitch card-power-toggle">
            <input
              type="checkbox"
              id={ switchId }
              className="onoffswitch-checkbox"
              name="onoffswitch"
              checked={this.props.power}
              onChange={this.togglePower}/>
            <label htmlFor={switchId} className="onoffswitch-label">
              <span className="onoffswitch-inner"></span>
              <span className="onoffswitch-switch"></span>
            </label>
          </div>
        </div>
      </div>
    )
  }
}
