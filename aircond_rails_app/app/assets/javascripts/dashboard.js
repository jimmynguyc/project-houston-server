 $(document).ready(function() {
  timer();
  $('td').hover(function(){
      $(this).parent().addClass('shadow')
    },function(){
      $(this).parent().removeClass('shadow')
  })

  $('.ac_row').hover(function(){
      $(this).addClass('shadow')
    },function(){
      $(this).removeClass('shadow')
  })


  $('.ac_row').click(function(){
        window.location.replace('http://'+ window.location.hostname + ':' + window.location.port + '/airconds/'+$(this).attr('id') + '/edit' )
    })
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
    // console.log('At the beginning')
    houston_db.ref('airconds/'+ $(selector).attr('id')).on('value', function(snapshot) { 
      ['.ac_status','.ac_mode','.ac_temperature','.ac_fan_speed'].forEach(function(filter){
        realtime_view_updates(selector,filter,snapshot)    
      })
      
      console.log(snapshot.val())
      // console.log('Triggered update')
      $.ajax({
        type: 'POST', 
        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
        url: '/firebase_update/' + $(selector).attr('id'),
        data: {aircond: snapshot.val()},
      })
    })
 })

  $('#location').on('change',function(event){
    var filter = $('#location').val()
    $('.layout').hide() 
    $('.layout#' + filter).show()
  })
  $('.layout_tile').draggable({containment:'parent'})




}

var realtime_view_updates = function(selector,class_filter,snapshot){
  $(selector).find(class_filter).each(function(index,value){
    // console.log('Triggered selector ' + class_filter)
    var replace_value = String(snapshot.val()[class_filter.split('.ac_')[1]])
    var element_attr = class_filter.split('.ac_')[1]
    var image_class = ''
    if(element_attr=='status'){
      image_class = 'power-' + replace_value.toLowerCase()+ '-01'
    }else if(element_attr=='mode'){
      image_class = 'mode-'+ replace_value.toLowerCase() + '-on'
    }else if(element_attr=='fan_speed'){
      image_class = 'speed-'+replace_value.toLowerCase() + '-on'
    }else if(element_attr=='temperature'){
      image_class = 'temp-' + replace_value.toLowerCase()
    }

    if(replace_value == 'undefined'){
      $(value).html('NA')
    }else{
      $(value).html("<img class='fit-img-size' align='middle' src='/NEXT-AC-assets/"+ image_class+".png' alt='Power on 01'>")
    }
    if(class_filter == '.ac_status'){
      if($(this).text() == 'ON'){
        $('#' + $(this).attr('id')+'.layout_tile').css('background','green')
      } else if ($(this).text() == 'OFF'){
        console.log('OFF')
        $('#' + $(this).attr('id')+'.layout_tile').css('background','red')
      } 
    }
  })
}

