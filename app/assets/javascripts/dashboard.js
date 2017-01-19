 $(document).ready(function() {
  timer();
 });

 var timer = function(){
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


  var houston_db= firebase.database();


  $('.aircond').each(function(index,selector){
    console.log('At the beginning')
    houston_db.ref('airconds/'+ $(selector).attr('id')).on('value', function(snapshot) { 
      ['.ac_status','.ac_mode','.ac_temperature','.ac_fan_speed'].forEach(function(filter){
        realtime_view_updates(selector,filter,snapshot)    
      })


      console.log('Triggered update')
      $.ajax({
        type: 'POST',
        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
        url: '/firebase_update/' + $(selector).attr('id'),
        data: {aircond: snapshot.val()},
      })
    })
 })
}

var realtime_view_updates = function(selector,class_filter,snapshot){
  $(selector).find(class_filter).each(function(index,value){
    console.log('Triggered selector ' + class_filter)
    $(value).text(
      String(snapshot.val()[class_filter.split('.ac_')[1]])
    )
  })
}
