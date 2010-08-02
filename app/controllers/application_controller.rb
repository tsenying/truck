# require 'gdata'
class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
  
  private
  
  def gmap
    puts "GData::Maps::Base.config['map']=#{GData::Maps::Base.config['map']}"
    @gmap ||= GData::Maps::Map.find_by_title(GData::Maps::Base.config['map'])
    logger.debug("@gmap=#{@gmap.inspect}")
    @gmap
  end
end
