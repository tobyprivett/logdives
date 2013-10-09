$(document).ready(function() {

  $('select#dive_template').change(function(){
    val = $(this).attr('value');
    if (val == 'rec'){
      $('.rec-icon').show(); $('.tec-icon').hide();
    }
    else {
      $('.tec-icon').show(); $('.rec-icon').hide();
    }
    $('#reload_page_prompt').show();
  })

  $('#link_to_submit_dive_form').click(function(){
      $('.formtastic').submit();
  })


  $("input.location").autocomplete({
    source: '/dive_sites.js',
    minLength: 2,
    delay: 10,
  });

  $("input.buddy_email").autocomplete({
    source: '/users.js',
    minLength: 3,
    delay: 10
  });

  $("input#dive_dive_date").datepicker({
      dateFormat: "dd M, yy"
    });

  $("input.waypoint_name").autocomplete({
    source: ['Safety stop', 'Deco stop', 'Deep stop', 'Max depth', 'Gas switch', 'Shark sighting!']
  });


  $("#add_tank_to_dive").click(function(){
    tank_count = $("input#dive_tank_count").attr('value');
    tank_count++;

    for (i = 0; i < tank_count; i++){
      $("#dive_tanks_attributes_" + i + "_nested").attr('value', '');
      $("#tank_" + i).show();
    }
    $("input#dive_tank_count").attr('value', tank_count);
    $("#dive_tanks_attributes_" + (tank_count -1) + "_start_pressure").focus();

    if (tank_count == 6) { $("#add_tank_to_dive").hide(); }
    if (tank_count > 0) { $("#remove_tank_from_dive").show(); }
    return false;
  });

  $("#remove_tank_from_dive").click(function(){
    tank_count = $("input#dive_tank_count").attr('value');
    tank_count = tank_count - 1
    $("#dive_tanks_attributes_" + tank_count + "_nested").attr('value', 'deleted');
    $("#tank_" + tank_count).css('display', 'none');

    $("input#dive_tank_count").attr('value', tank_count);
    if (tank_count == 0) {
      $("#remove_tank_from_dive").hide();
    }
    return false;
  });

  $(".mix-selector").change(function(){
    var div = $(this).parents("div")[0];
    var mix = this.value;

    o2 = $(div).children('li').filter('.o2')[0];
    he = $(div).children('li').filter('.he')[0];

    if (mix == 'Air') {
      $(o2).hide(); $(he).hide(); $(n2).hide;
    }
    else if (mix == 'Nitrox') {
      $(o2).show();  $(he).hide();
    }
    else if (mix == 'Trimix') {
      $(o2).show(); $(he).show();
    }
    else if (mix == 'Heliox') {
      $(o2).show(); $(he).show();
    }

  })


  $(".nitrox-selector").change(function(){
    if (this.value == 'Air') {
      $('#dive_tanks_attributes_0_o2_input').hide();
    }
    else {
      $('#dive_tanks_attributes_0_o2_input').show();
    }

  })

  $("#add_waypoint_to_dive").click(function(){
    waypoint_count = $("input#dive_waypoint_count").attr('value');
    waypoint_count++;

    for (i = 0; i < waypoint_count; i++){
      $("#dive_waypoints_attributes_" + i + "_nested").attr('value', '');
      $("#waypoint_" + i).show();
    }
    $("input#dive_waypoint_count").attr('value', waypoint_count);
    $("#dive_waypoints_attributes_" + (waypoint_count -1) + "_time").focus();

    if (waypoint_count == 6) { $("#add_waypoint_to_dive").hide(); }
    if (waypoint_count > 0) { $("#remove_waypoint_from_dive").show(); }
    return false;
  });

  $("#remove_waypoint_from_dive").click(function(){
    waypoint_count = $("input#dive_waypoint_count").attr('value');
    waypoint_count = waypoint_count - 1
    $("#dive_waypoints_attributes_" + waypoint_count + "_nested").attr('value', 'deleted');
    $("#waypoint_" + waypoint_count).css('display', 'none');

    $("input#dive_waypoint_count").attr('value', waypoint_count);
    if (waypoint_count == 0) {
      $("#remove_waypoint_from_dive").hide();
    }
    return false;
  });

  $("#add_buddy_to_dive").click(function(){
    buddy_count = $("input#dive_buddy_count").attr('value');
    buddy_count++;

    for (i = 0; i < buddy_count; i++){
      $("#dive_buddies_attributes_" + i + "_nested").attr('value', '');
      $("#buddy_" + i).show();
    }
    $("input#dive_buddy_count").attr('value', buddy_count);
    $("#dive_buddies_attributes_" + (buddy_count -1) + "_start_pressure").focus();

    if (buddy_count >= 3) { $("#add_buddy_to_dive").hide(); }
    return false;
  });



  function set_fieldset_on(id){
      $('#dive_' + id + '_visible').attr('value', '1');
      $('#' + id + '-on').show();
      $('#' + id + '-off').hide();
  }

 function set_fieldset_off(id){
      $('#dive_' + id + '_visible').attr('value', '0');
      $('#' + id + '-on').hide();
      $('#' + id + '-off').show();
  }


  $('#show_buddy').click(function(){ set_fieldset_on('buddy'); return false;});
  $('#hide_buddy').click(function(){ set_fieldset_off('buddy'); return false;});
  $('#show_conditions').click(function(){ set_fieldset_on('conditions'); return false;});
  $('#hide_conditions').click(function(){ set_fieldset_off('conditions'); return false;});
  $('#show_equipment').click(function(){ set_fieldset_on('equipment'); return false;});
  $('#hide_equipment').click(function(){ set_fieldset_off('equipment'); return false;});
  $('#show_profile').click(function(){ set_fieldset_on('profile'); return false;});
  $('#hide_profile').click(function(){ set_fieldset_off('profile'); return false;});
  $('#show_tanks').click(function(){ set_fieldset_on('tanks'); return false;});
  $('#hide_tanks').click(function(){ set_fieldset_off('tanks'); return false;});
  $('#show_photos').click(function(){ set_fieldset_on('photos'); return false;});
  $('#hide_photos').click(function(){ set_fieldset_off('photos'); return false;});
  $('#show_notes').click(function(){ set_fieldset_on('notes'); return false;});
  $('#hide_notes').click(function(){ set_fieldset_off('notes'); return false;});

  $('input:submit').button();

});
