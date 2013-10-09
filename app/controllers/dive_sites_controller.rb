class DiveSitesController < ApplicationController
  def index
    if params[:term]
      @dive_sites = DiveSite.all(:conditions => ["site like ? or location like ?", params[:term] + '%', params[:term] + '%'])
    else
      @dive_sites = DiveSite.limit(100)
    end
    respond_to do |format|
      format.html {render :layout => false}
      format.js
    end
  end



  def new
    @dive_site = DiveSite.new
  end

  # def show
  #     @dive_site = DiveSite.find(params[:id])
  #
  #     @map = Cartographer::Gmap.new( 'map' )
  #       @map.zoom = :bound
  #       @map.icons << Cartographer::Gicon.new
  #       marker1 = Cartographer::Gmarker.new(:name=> "taj_mahal", :marker_type => "Building",
  #                   :position => [27.173006,78.042086],
  #                   :info_window_url => "/dive_sites")
  #       marker2 = Cartographer::Gmarker.new(:name=> "raj_bhawan", :marker_type => "Building",
  #                   :position => [28.614309,77.201353],
  #                   :info_window_url => "/url_for_info_content")
  #
  #       @map.markers << marker1
  #       @map.markers << marker2
  #   end
end
