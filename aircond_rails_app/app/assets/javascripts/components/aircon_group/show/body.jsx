class AirconGroupShowBody extends React.Component {
  render(){
    const { aircons } = this.props

    return(
      <div id="aircon-group-show-body">
        <div className="flex-container">
          {
            aircons.map( (aircon) => {
              return(<CardContainer aircon={aircon} key={`aircon-${aircon.id}`} />)
            })
          }
        </div>
      </div>
    )
  }
}


