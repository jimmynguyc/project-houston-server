class CardMode extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      // temp: this.props.temp
    }
    this.tempUp = this.tempUp.bind(this)
    this.tempDown = this.tempDown.bind(this)
    this.modeFan = this.modeFan.bind(this)
    this.modeDry = this.modeDry.bind(this)
    this.modeCold = this.modeCold.bind(this)
  }

  modeDry() {
    this.props.modeChangeHandler('dry')
  }

  modeCold() {
    this.props.modeChangeHandler('cold')
  }

  modeFan() {
    this.props.modeChangeHandler('fan')
  }

  tempUp() {
    if (this.props.temp < 30) {
      this.props.tempChangeHandler(this.props.temp + 1)
    }
  }

  tempDown() {
    if (this.props.temp > 16) {
      this.props.tempChangeHandler(this.props.temp - 1)
    }
  }

  render() {

    let fanClass = classNames({ 'pmd-btn-outline': (this.props.mode == 'fan' && this.props.power)})
    let dryClass = classNames({ 'pmd-btn-outline': (this.props.mode == 'dry' && this.props.power)})
    let coldClass = classNames({ 'pmd-btn-outline': (this.props.mode == 'cold' && this.props.power)})

    let tempButtonClass = classNames(
      'btn',
      'pmd-ripple-effect', { 'btn-default': this.props.power }, { 'pmd-btn-raised': this.props.power }
    )

    // let tempDisplay =

    return (
      <div className="pmd-card-media">
        <div className="media-body">
          <div className="h5">MODE</div>
          <div className="card-mode-container">
            <span className="card-mode-btns">
              <button className={`btn pmd-btn-raised pmd-btn-fab pmd-ripple-effect btn-default ${coldClass}`} onClick={this.modeCold} disabled={!this.props.power} type="button" data-toggle="tooltip" data-placement="bottom" title="Cold">
                <i className="fa fa-snowflake-o fa-2x"></i>
              </button>
            </span>
            <span className="card-mode-btns">
              <button className={`btn pmd-btn-raised pmd-btn-fab pmd-ripple-effect btn-default ${dryClass}`} onClick={this.modeDry} disabled={!this.props.power} type="button" data-toggle="tooltip" data-placement="bottom" title="Dry">
                <i className="fa fa-tint fa-2x"></i>
              </button>
            </span>
            <span className="card-mode-btns">
              <button className={`btn pmd-btn-raised pmd-btn-fab pmd-ripple-effect btn-default ${fanClass}`} onClick={this.modeFan} disabled={!this.props.power} type="button" data-toggle="tooltip" data-placement="bottom" title="Fan">
                <i className="fa fa-sun-o fa-2x"></i>
              </button>
            </span>
          </div>
        </div>

        <div className="media-right">
          <div className="pmd-display3" id="card-temp-display">{this.props.temp}°C</div>
          <div className="btn-group btn-group-xs card-temp-btns" role="group">
            <button className={tempButtonClass} onClick={this.tempUp} id="temp-up" disabled={!this.props.power || this.props.mode == 'cold'} type="button">
              <i className="fa fa-chevron-up"></i>
            </button>
            <button className={tempButtonClass} onClick={this.tempDown} id="temp-down" disabled={!this.props.power || this.props.mode == 'cold'} type="button">
              <i className="fa fa-chevron-down"></i>
            </button>
          </div>
        </div>
      </div>
    )
  }
}
