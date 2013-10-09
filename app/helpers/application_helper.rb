module ApplicationHelper

  def page_title(dive)
    ret = "Logdives.com"
    if @dive && !@dive.new_record?
      ret += " : #{(dive.diver_name + ' logged a dive at ') unless obfuscatable?(dive.diver)}#{dive.location}"
    end
    ret
  end

  def dive_profile_image(dive_object)
    profile_image_url = dive_object.profile_image_url
    return unless profile_image_url.present?
    render :partial => 'dives/fields/profile_image', :locals => { :profile_image_url => profile_image_url }
  end

  def link_to_profile(user_obj)
    return '' unless user_obj
    link_to obfuscate_name(user_obj), profile_path(user_obj)
  end

  def obfuscatable?(user_obj)
    return false unless user_obj.name_accessor.blank?
    return false if user_signed_in? && current_user.friends.include?(user_obj)
    true
  end

  def obfuscate_name(user_obj)
    obfuscatable?(user_obj) ? 'anonymous' : user_obj.name
  end

  def link_to_toggle_unit(text, target_units)
    link_to "Use #{text}", {:units => target_units}
  end

  def link_to_viewer(dive_obj)
    target =  @u == dive_obj.diver ? edit_dive_path(dive_obj) : viewer_path(dive_obj)
    link_to_unless @dive == dive_obj, "#{dive_obj.location}", target, :remote => true
  end

  def minutes(time_s)
    "#{pluralize(time_s, "minute")}" if time_s.to_i > 0
  end

  def spacer
    '&nbsp;'.html_safe
  end

  def write_flash
    render :partial => '/shared/flash', :locals => {:flash => flash}
  end


  def row_spacer(length='10')
    "<div class='row'><div class='column grid_#{length}'>&nbsp;</div></div>".html_safe
  end

  def static_rating_stars(rating)
    return '' unless rating > 0
    image_tag "rating_#{rating}.gif", :class => 'rating_image'
  end

end
