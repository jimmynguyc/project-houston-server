$(document).ready(function(){
	$('#aircond_mode').on('change',function(){

		var selection = $(this).children('option:selected').text()
		$.ajax({
			type: 'POST',
			beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
			url: '/limit_options',
			data: {mode: selection},
			success: function(options){
				filter_options('#ac_fan_speed',options.fan_speed)
				filter_options('#ac_temperature',options.temperature)
			}
		})
	})	
})


var filter_options =function(selector,condition){
	if(condition.length === 0){
		remove_element(selector)
	}else{
		if($('form#edit_aircond_1').children(selector).html() === '' ){
			modify_element(selector,condition)
		}else{
			modify_element(selector,condition)
		}
	}
}


var remove_element = function(selector){
	if(selected_element(selector).html() === '' ){
	}else{
		selected_element(selector).html('')	
	}
}

var modify_element = function(selector,options){
	if(selector === '#ac_temperature'){
		label_text = 'Temperature'
	}else if(selector === '#ac_fan_speed'){
		label_text = 'Fan speed'
	}
	name = selector.replace('#ac_','')
	
	html_input = '<label for="aircond_' + name + '">'+label_text +'</label>' + '<select name="aircond['+name+']" id="aircond_'+ name +'">' + 	possible_options(options)+'</select>'
	selected_element(selector).html(html_input)
}

var selected_element = function(selector){
	return $('form#edit_aircond_1').children(selector)
}

var possible_options = function(options){
	output = ''
	$.each(options,function(index,value){
		output = output + '<option value='+value+'>'+value+'</option>'
	})
	return output
}

