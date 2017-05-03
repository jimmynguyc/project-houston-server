class AirconGroupShowBody extends React.Component {
  render(){
    const { aircons } = this.props

    return(
      <div id="aircon-group-show-body">
        {
          aircons.map( (aircon) => {
            return(<CardContainer aircon={aircon} />)
          })
        }
      </div>
    )
  }
}


