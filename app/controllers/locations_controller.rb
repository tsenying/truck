class LocationsController < ApplicationController
  def markers
    if params[:bounds].blank?
      raise "Missing bounding box"
    end
    if params[:zoom].blank?
      raise "Missing zoom level"
    end

    lat_lo, lng_lo, lat_hi, lng_hi = params[:bounds].split(',').map{|e| e.to_f} #"lat_lo,lng_lo,lat_hi,lng_hi"
    zoom = params[:zoom].to_i

    markers = [] 
    # box=west,south,east,north (lng_lo, lat_lo, lng_hi, lat_hi)
    box = "box=#{lng_lo},#{lat_lo},#{lng_hi},#{lat_hi}"
    response = gmap.find_features(box)
    entries = response.parse_xml.css('atom|entry')
    puts "box=#{box}, number of features found=#{entries.size}"
    logger.debug("box=#{box}, number of features found=#{entries.size}")
    markers = set_markers(entries)

    respond_to do |format|
      # format.html # index.html.erb
      format.json { render :text => markers.to_json }
    end
    
  rescue
    puts $!
    logger.error $!
    respond_to do |format|
      # format.html # index.html.erb
      format.json { render :text => [].to_json }
    end
  end
  
  # GET /locations
  # GET /locations.xml
  def index
    @locations = Location.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @locations }
    end
  end

  # GET /locations/1
  # GET /locations/1.xml
  def show
    @location = Location.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @location }
    end
  end

  # GET /locations/new
  # GET /locations/new.xml
  def new
    @location = Location.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @location }
    end
  end

  # GET /locations/1/edit
  def edit
    @location = Location.find(params[:id])
  end

  # POST /locations
  # POST /locations.xml
  def create
    @location = Location.new(params[:location])

    respond_to do |format|
      if @location.save
        format.html { redirect_to(@location, :notice => 'Location was successfully created.') }
        format.xml  { render :xml => @location, :status => :created, :location => @location }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @location.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /locations/1
  # PUT /locations/1.xml
  def update
    @location = Location.find(params[:id])

    respond_to do |format|
      if @location.update_attributes(params[:location])
        format.html { redirect_to(@location, :notice => 'Location was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @location.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.xml
  def destroy
    @location = Location.find(params[:id])
    @location.destroy

    respond_to do |format|
      format.html { redirect_to(locations_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def set_markers(entries)
    all = []
    entries.each do |entry|
      re = Regexp.new("#{GData::Maps::Base.config["feeds_url"]}/features/[[:xdigit:]]+/[[:xdigit:]]+/([[:xdigit:]]+)")
      feature_id = re.match(entry.at_css('atom|id').content)[1]
      
      coordinates = entry.at_css('Placemark Point coordinates').content.split(',')
      
      marker = { :key => feature_id, # unique key for markers hash in js
                 :type => 'truck',
                 :name => entry.at_css('Placemark name').content,
                 :description => entry.at_css('Placemark description').content,
                 :lat => coordinates[1],
                 :lng => coordinates[0] }
      all << marker
    end
    all
  end
end
