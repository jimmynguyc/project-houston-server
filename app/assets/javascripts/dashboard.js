 $(document).ready(function() {

  $('#timezone_form').hide(); //Initially form wil be hidden.

  $('#timezone_button').click(function(event) {
  	event.preventDefault()
   $('#timezone_form').show();//Form shows on button click
   $('#timezone_button').hide()
   });

  var increment_by_1= function(selector){return parseInt(selector.text())+1}
  var adjust_output= function(integer){
  	if(integer.toString().length == 1){
  		return '0'+integer.toString()
  	}else{
  	  	return integer	
  	  }
  }

  window.setInterval(function(){	
	  if(increment_by_1($('#current_sec')) === 60){
	  	$('#current_sec').text('00')
	  	if(increment_by_1($('#current_min')) === 60){
	  		$('#current_min').text('00')
	  		if(increment_by_1($('#current_hour')) === 24){
	  			$('#current_hour').text('00')
	  		}else{
	  			$('#current_hour').text(adjust_output(increment_by_1($('#current_hour'))))

	  		}
	    }else{
	  		$('#current_min').text(adjust_output(increment_by_1($('#current_min'))))
	    }
	  }else{
	  	$('#current_sec').text(adjust_output(increment_by_1($('#current_sec'))))
	  }
  },1000)
 });