$(document).ready(function(){
  $(document).on('click','.ac_group_selector',function(){

    $.ajax({
      url: '/aircond_group_dashboard.js?group_id=' + $(this).attr('id').split('_')[1] ,
      type: 'GET'
    })
  })
})



dragula([document.querySelector('#aircond_group'), document.querySelector('#right')])