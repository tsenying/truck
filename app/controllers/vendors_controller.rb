class VendorsController < ApplicationController
  # GET /vendors
  # GET /vendors.xml
  def index
    @vendors = Vendor.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @vendors }
    end
  end

  # GET /vendors/1
  # GET /vendors/1.xml
  def show
    @vendor = Vendor.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @vendor }
    end
  end

  # GET /vendors/new
  # GET /vendors/new.xml
  def new
    # TODO: use nested forms to create location as well
    @vendor = Vendor.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @vendor }
    end
  end

  # GET /vendors/1/edit
  def edit
    @vendor = Vendor.find(params[:id])
  end

  # POST /vendors
  # POST /vendors.xml
  def create
    unless params[:twitter_user].blank?
      begin
        @vendor = Vendor.new # should fail validation
        logger.debug "params[:twitter_user]=#{params[:twitter_user]}"
        logger.debug "Twitter=#{Twitter}"
        user = Twitter.user(params[:twitter_user])
        @vendor.name = user.name
        @vendor.location = user.location
        @vendor.url = user.url
        @vendor.description = user.description
        @vendor.followers = user.followers_count
        @vendor.following = user.friends_count
        # @vendor.listed = user.listed
        @vendor.tweets = user.statuses_count
        
        # run location through geocoder and create a home location
        if latlng = SimpleGeocoder::Geocoder.new.find_location(user.location)
          @vendor.locations << Location.new({:name => 'home', :location => user.location, :latitude => latlng['lat'], :longitude => latlng['lng']})
        else
          logger.warn "failed to geocode location:#{user.location}"
        end
      rescue => e
        puts "user=#{user.inspect}"
        logger.warn "Cannot find twitter user: #{params[:twitter_user]} - exception:" + e.inspect
        logger.warn e.backtrace.join("\n")
      end
    else
      @vendor = Vendor.new(params[:vendor])
    end
    
    respond_to do |format|
      if @vendor.save
        format.html { redirect_to(@vendor, :notice => 'Vendor was successfully created.') }
        format.xml  { render :xml => @vendor, :status => :created, :location => @vendor }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @vendor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /vendors/1
  # PUT /vendors/1.xml
  def update
    @vendor = Vendor.find(params[:id])

    respond_to do |format|
      if @vendor.update_attributes(params[:vendor])
        format.html { redirect_to(@vendor, :notice => 'Vendor was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @vendor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /vendors/1
  # DELETE /vendors/1.xml
  def destroy
    @vendor = Vendor.find(params[:id])
    @vendor.destroy

    respond_to do |format|
      format.html { redirect_to(vendors_url) }
      format.xml  { head :ok }
    end
  end
end
