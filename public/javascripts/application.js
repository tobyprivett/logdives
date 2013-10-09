$(document).ready(function() {
  $('.dive_details_button').button();
  $('input:submit').button();

  $('#dive_feed').ajaxStart(function(){
    $('#loading').html('Loading...');
    $("#loading").show();
  })
  $('#dive_feed').ajaxStop(function(){
    $('#loading').html('');
    $("#loading").hide();
  });


  $('#divealert').ajaxStart(function(){
    $("#loading").show();
  })
  $('#divealert').ajaxStop(function(){
    $("#loading").hide();
  });
});