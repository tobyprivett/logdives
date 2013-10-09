module PublicDivesHelper

  def link_to_dive_assets(dive_obj)
    link_to dive_obj.active_assets.join(", "), viewer_path(dive_obj), :id => "dive_assets_#{dive_obj.id}", :class => 'show-dive-assets'
  end

end
