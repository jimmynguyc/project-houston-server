class CardContainer extends React.Component {
  constructor(props) {
    super(props)
    const {aircon} = this.props;

    this.state = this.stateFromAircon(aircon)

    this.tempChangeHandler = this.tempChangeHandler.bind(this)
    this.modeChangeHandler = this.modeChangeHandler.bind(this)
    this.powerToggleHandler = this.powerToggleHandler.bind(this)
    this.sendSignal = this.sendSignal.bind(this)
    this.restartTimer = this.restartTimer.bind(this)
  }

  parsePower(powerStatus){
    switch (powerStatus) {
      case 'ON':
        return true
        break;
      case 'OFF':
        return false
        break;
      case true:
        return "ON"
        break;
      case false:
        return "OFF"
        break;
    }
  }

  stateFromAircon(aircon) {
    return(
      {
        power: this.parsePower(aircon.status),
        temp: aircon.temperature,
        mode: aircon.mode.toLowerCase(),
        fanSpeed: aircon.fan_speed,
        onTime: '8:00',
        offTime: '21:00',
        timeOut: null,
        isRequesting: false
      }
    )
  }

  componentDidMount() {
    $('[data-toggle="tooltip"]').tooltip()
  }

  restartTimer() {
    clearTimeout(this.state.timeOut)
    this.state.timeOut = setTimeout(this.sendSignal, 1500)
  }

  tempChangeHandler(val) {
    this.setState({temp: val})
    this.restartTimer()
  }

  modeChangeHandler(val) {
    this.setState({mode: val})
    this.restartTimer()
  }

  powerToggleHandler(val) {
    this.setState({power: val})
    this.restartTimer()
  }

  sendSignal() {
    const { aircon } = this.props;
    const endpoint = window.location.origin + "/airconds/" + aircon.id

    const data = {
      aircond: {
        status: this.parsePower(this.state.power),
        temperature: this.state.temp,
        mode: this.state.mode.toUpperCase(),
        fan_speed: "1"
      }
    }

    $.ajax({
      url: endpoint,
      method: 'PATCH',
      data: data,
      dataType: 'JSON',
      beforeSend: () => {
        this.setState({isRequesting: true})
      },
      success: e => {
        clearTimeout(this.state.timeOut)
        newState = this.stateFromAircon(e)
        this.setState(newState)
      }.bind(this),
      complete: e => {
        this.setState({isRequesting: false})
      },
      error: e => {
        console.log("Error")
        console.log(e)
      }
    })
  }


  render() {
    let cardClass = classNames(
      'pmd-card',
      'pmd-z-depth',
      'pmd-card-media-inline',
      {'pmd-card-inverse': !this.state.power}
    )

    let overlayClass = classNames(
      'overlay',
      {'show-appear': this.state.isRequesting},
      {'hide-appear': !this.state.isRequesting}
    )

    return (
      <div className="card-container">
        <div className={cardClass}>
          <div className={overlayClass}>
            Sending Signal...
          </div>
          <CardHeader
            title={this.props.aircon.alias}
            power={this.state.power}
            powerToggleHandler={this.powerToggleHandler} />
          <CardMode
            power={this.state.power}
            mode={this.state.mode}
            temp={this.state.temp}
            tempChangeHandler={this.tempChangeHandler}
            modeChangeHandler={this.modeChangeHandler} />
          <CardFan
            power={this.state.power}
            mode={this.state.mode}
            fan={this.props.fan} />
          <CardTimer
            onTime={this.state.onTime}
            offTime={this.state.offTime}
            power={this.state.power} />
        </div>
      </div>
    )
  }
}


// class CardContainer extends React.Component {
//   render() {
//     return (
//       <div className="pmd-card pmd-card-default pmd-z-depth pmd-card-media-inline card">
//         <CardHeader />
//         <CardMode />
//         <CardTemperature />
//         <CardFan />
//         <CardTimer />
//       </div>
//     )
//   }
// }

