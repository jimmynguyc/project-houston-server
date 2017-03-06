$(document).ready(function(){
  drake = dragula()
  flexible_column()
  set_containers()
  $(document).on('click','.ac_group_selector',function(){
    $.ajax({
      url: '/aircond_groups.js?group_id=' + $(this).attr('id').split('_')[1] ,
      type: 'GET'
    })
  })

  drake.on('drop',function(el, target, source, sibling){
    new_id= $(target).closest('.aircond_group').attr('id').split('_')[2]
    form = $(el).children()
    form.children('#aircond_aircond_group_id').val(new_id)
    form.submit()
  })
})

flexible_column = function(){
  $('.aircond_group').removeClass(function (index, className) {
    return (className.match (/(^|\s)col-sm-\d*/g) || []).join(' ');
  });

  col_length = 12/$('.aircond_group').size()
  if( col_length < 4){
    col_length = 4
  }else if(col_length == 12){
    col_length = 6
  }
  
  $('.aircond_group').addClass('col-sm-'+String(col_length))
}

set_containers = function(){
  containers = []
  $('.ac_group_body').each(function(index, value){ containers.push(value)})
  drake.containers = containers
}