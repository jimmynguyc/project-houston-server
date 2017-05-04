class CardTimer extends React.Component {
  constructor(props) {
    super(props);
  }

  componentDidMount() {
    $('.on').datetimepicker({
      format: 'LT',
      defaultDate: '1/1/2017 ' + this.props.onTime
    });

    $('.off').datetimepicker({
      format: 'LT',
      defaultDate: '1/1/2017 ' + this.props.offTime
    });
  }

  render() {

    let timerClass = classNames(
      'pmd-card-actions',
      'card-timer-container', { 'card-timer-disabled': !this.props.power }
    )

    return(
      <div className={timerClass}>
        <div className="row">
          <div id="on-timer-container" className="col-xs-6">
            <h5 className="up">ON</h5>
            <div className="timepicker-box">
              <input type="text" className="timepicker on"/>
              <i className="fa fa-clock-o timer-icon"></i>
            </div>
          </div>

          <div id="off-timer-container" className="col-xs-6">
            <h5 className="up">OFF</h5>
            <div className="timepicker-box">
              <input type="text" className="timepicker off"/>
              <i className="fa fa-clock-o timer-icon"></i>
            </div>
          </div>
        </div>
      </div>
    )
  }
}