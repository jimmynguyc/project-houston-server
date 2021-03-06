$(document).ready(function(){
	$(document).on('click','form #ac_status img', function(){
		var container = $(this).closest('.col-sm-12')
		var replace_value = $(this).attr('src').replace('/NEXT-AC-assets/','').split('-')[1]
	    if(replace_value =='on'){
	    	var original_value = 'on'
	    	replace_value = 'off'
	    }else {
	    	var original_value = 'off'
	    	replace_value = 'on'
	    }
		set_hidden_form_val(container,replace_value)

	  $(this).parent().html("<img style='height:300px' align='middle' src='"+ $(this).attr('src').replace(original_value,replace_value)+ "'>")
	})

	$(document).on('click','form #ac_mode img', function(){
		var current_img_container = $(this).closest('.col-sm-2')
		var container = $(this).closest('.col-sm-12')
		var replace_value = $(this).attr('src').replace('/NEXT-AC-assets/','').split('-')[1]
		var element_attr = container.attr('id')
	  if(element_attr=='ac_mode'){
	    var source = 'mode-'+ replace_value + '-on'
	    var img_class = "class='fit-img-size'"
	    var style = ''
	    var alt='Mode ' + replace_value + ' on'
	  }

		$.ajax({
			type : 'get',
			url : window.location.pathname,
			data : {mode:replace_value.toUpperCase()},
			dataType : 'JSON',
			success: function(selection){
				var condition1 = selection.fan_speed
				var condition2 = selection.temperature
				var selector1 = '#ac_fan_speed'
				var selector2 = '#ac_temperature'
				var all_fan_selection = ['AUTO','1','2','3']

				if(condition1.length === 0){
					$('form ' + selector1 + '.col-sm-12 input' ).val('')
					$(all_fan_selection).each(function(ind,val){
						$('form ' + selector1 + '.col-sm-12 #speed_' + val.toLowerCase() ).html('')
					})
				}else{
					$('form ' + selector1 + '.col-sm-12 input' ).val(condition1[0])
					$(all_fan_selection).each(function(ind,val){
						$('form ' + selector1 + '.col-sm-12 #speed_' + val.toLowerCase() ).html('')
					})
					$(condition1).each(function(ind,val){
						if(val == condition1[0] ){
							$('form ' + selector1 + '.col-sm-12 #speed_' + val.toLowerCase() ).html("<img class='fit-img-size' align='middle' src='/NEXT-AC-assets/speed-" + val.toLowerCase() +"-on.png' alt='Speed " + val.toLowerCase()+" on'>")
						}else{
							$('form ' + selector1 + '.col-sm-12 #speed_' + val.toLowerCase() ).html("<img class='fit-img-size' align='middle' src='/NEXT-AC-assets/speed-" + val.toLowerCase() +"-off.png' alt='Speed " + val.toLowerCase()+" off'>")
						}
					})
				}

				if(condition2.length === 0){
					$('form #ac_temperature.col-sm-12 #temp_input').html("<input type='hidden' name = aircond[temperature] value ='' ></input>")
					$('form #ac_temperature.col-sm-12 #temp_img').html('')
				}else {
					$('form #ac_temperature.col-sm-12 #temp_input').html("<input min='" + String(condition2[0]) + "' max='" + String(condition2[condition2.length -1 ]) + "' type='range' value='" + String(condition2[0]) + "' name='aircond[temperature]' id='aircond_temperature'>")
					$('form #ac_temperature.col-sm-12 #temp_img').html("<img class='fit-img-size ' align='middle' src='/NEXT-AC-assets/temp-" + String(condition2[0]) + ".png' alt='Temp " + String(condition2[0]) + "'>")
				}
			}
		})

		set_hidden_form_val(container,replace_value)

		container.children('div').children('img').each(function(ind,el){
			$(el).parent().html("<img " + img_class + style + " align='middle' src='" + $(el).attr('src').replace('on','off') + " ' alt='" + alt.replace('on','off') + "'>")
		})

		current_img_container.html("<img " + img_class +  style + " align='middle' src='"+ $(this).attr('src').replace('off','on')  + "' alt='"+ alt + "'>")
	})

	$(document).on('click','form #ac_fan_speed img', function(){
		var current_img_container = $(this).closest('.col-sm-2')
		var container = $(this).closest('.col-sm-12')
		var replace_value = $(this).attr('src').replace('/NEXT-AC-assets/','').split('-')[1]
		var element_attr = container.attr('id')

	    var source = 'speed-'+replace_value + '-on'
	    var img_class = "class='fit-img-size'"
	    var style = ''
 	    var alt='Speed ' + replace_value + ' on'

		set_hidden_form_val(container,replace_value)

		container.children('div').children('img').each(function(ind,el){
			$(el).parent().html("<img " + img_class + style + " align='middle' src='" + $(el).attr('src').replace('on','off') + " ' alt='" + alt.replace('on','off') + "'>")
		})

		current_img_container.html("<img " + img_class +  style + " align='middle' src='"+ $(this).attr('src').replace('off','on')  + "' alt='"+ alt + "'>")
	})

	$(document).on('change','form #ac_temperature.col-sm-12 input', function(){
		$('form #ac_temperature.col-sm-12 #temp_img').html("<img class='fit-img-size ' align='middle' src='/NEXT-AC-assets/temp-" + $(this).val() + ".png' alt='Temp 20'>")
	})

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
		modify_element(selector,condition)
	}
}


var remove_element = function(selector){

	name = selector.replace('#ac_','')
	if(selected_element(selector).html() === '' ){
	}else{
		selected_element(selector).html("<input type='hidden' name = aircond[" + name + "] value ='' ></input>")	
	}
}

var modify_element = function(selector,options){
	if(selector === '#ac_temperature'){
		label_text = 'Temperature'
	}else if(selector === '#ac_fan_speed'){
		label_text = 'Fan speed'
	}
	name = selector.replace('#ac_','')
	
	html_input = '<label for="aircond_' + name + '">'+label_text +'</label>' + '<select class =\'right_align form-control\' name="aircond['+name+']" id="aircond_'+ name +'">' + 	possible_options(options)+'</select>'
	selected_element(selector).html(html_input)
}

var selected_element = function(selector){
	return $('form#edit_aircond_settings').children(selector)
}

var possible_options = function(options){
	output = ''
	$.each(options,function(index,value){
		output = output + '<option value='+value+'>'+value+'</option>'
	})
	return output
}

var set_hidden_form_val = function(container,value){
	container.children('input').val(value.toUpperCase())
}