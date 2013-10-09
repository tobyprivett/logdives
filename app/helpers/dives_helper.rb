module DivesHelper
  def link_to_delete_buddy(buddy_obj)
    link_to "delete", buddy_path(buddy_obj), :method => 'delete', :confirm => 'Are you sure you want to remove this person?'
  end

  def on_state(visibility)
    {:style => (visibility ? '' : 'display:none')}
  end

  def off_state(visibility)
    {:style => (visibility ? 'display:none' : '')}
  end

  def link_to_show(id)
    link_to("show", "#", :id => "show_#{id}", :class => 'mini-link')
  end

  def link_to_hide(id)
    link_to("hide", "#", :id => "hide_#{id}", :class => 'mini-link')
  end

  def buddy_hint(buddy_obj)
    return "e.g. Instructor, Student, Buddy, Divemaster" if buddy_obj.new_record?
    render :partial => 'buddies/state', :locals => { :buddy => buddy_obj }
  end
end
