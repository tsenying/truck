require 'gdata'
class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
  
  def gmap
    @gmap ||= GData::Maps::Map.find_by_title("tweetruck")
    logger.debug("@gmap=#{@gmap.inspect}")
    @gmap
  end
end
