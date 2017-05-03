class CardContainer extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      power: this.props.power,
      temp: this.props.temp,
      mode: this.props.mode,
      onTime: this.props.ontime,
      offTime: this.props.offtime,
      timeOut: null,
      isRequesting: false
    }

    this.tempChangeHandler = this.tempChangeHandler.bind(this)
    this.modeChangeHandler = this.modeChangeHandler.bind(this)
    this.powerToggleHandler = this.powerToggleHandler.bind(this)
    this.sendSignal = this.sendSignal.bind(this)
    this.restartTimer = this.restartTimer.bind(this)
  }

  componentDidMount() {
    $('[data-toggle="tooltip"]').tooltip()
  }
  // componentDidUpdate(prevProps, prevState) {
  //   clearTimeout(this.state.timeOut)
  //   this.state.timeOut = setTimeout(this.sendSignal, 1000);
  // }

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
    $.ajax({
      url: 'http://slowwly.robertomurray.co.uk/delay/1000/url/https://jsonplaceholder.typicode.com/users/1',
      method: 'get',
      beforeSend: () => {
        this.setState({isRequesting: true})
      },
      success: e => {
        clearTimeout(this.state.timeOut)
        console.log(e)
      },
      complete: e => {
        this.setState({isRequesting: false})
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

    console.log(`----- rendering ${this.props.title} -----`)
    console.log(this.state)
    console.log(`----- ----- -----`)

    return (
      <div className="card-container">
        <div className={cardClass}>
          <div className={overlayClass}>
            Sending Signal...
          </div>
          <CardHeader
            title={this.props.title}
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

