class CardFan extends React.Component {
  render() {
    return(
      <div className="pmd-card-media">
        <div className="media-body">
          <div className="h5">FAN SPEED</div>
          <div className="btn-group card-fan-container">
            <button className="btn pmd-btn-raised pmd-ripple-effect btn-default" disabled={!this.props.power || this.props.mode == 'dry'}>Auto</button>
            <button className="btn pmd-btn-raised pmd-ripple-effect btn-default" disabled={!this.props.power || this.props.mode == 'dry'}>1</button>
            <button className="btn pmd-btn-raised pmd-ripple-effect btn-default" disabled={!this.props.power || this.props.mode == 'dry'}>2</button>
            <button className="btn pmd-btn-raised pmd-ripple-effect btn-default" disabled={!this.props.power || this.props.mode == 'dry'}>3</button>
          </div>
        </div>
      </div>
    )
  }
}