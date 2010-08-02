require 'test_helper'

class LocationsControllerTest < ActionController::TestCase
  def self.startup
    # @@client = GData::Client::Maps.new
    # @@client.clientlogin(Data::Maps::Base.config["maps"]['username'], Data::Maps::Base.config["maps"]['password'])
    # @@test_map = GData::Maps::Map.create(GData::Maps::Base.config['map'], "Functional Test Map.")
    @@test_map = GData::Maps::Map.find_by_title(GData::Maps::Base.config['map'])
    @@test_feature = @@test_map.create_feature('Feature Title', 'Feature Name', 'Feature Description', 
      coordinates_hash = {:longitude => '-105.2701', :latitude => '40.0151', :elevation => '1000.0'})
  end
  
  def self.shutdown
    GData::Maps::Feature.delete(@@test_feature)
    # response = GData::Maps::Map.delete(@@test_map.at_css("link[rel='edit']")['href'])
    # @@test_map = nil
    # @@client = nil
  end
  
  setup do
    @location = locations(:one)
  end

  test "get markers with no box param returns nothing" do
    get :markers, :format => 'json'
    puts response.content_type
    puts JSON.parse(response.body).inspect
    assert_response :success
    assert_equal '[]', response.body
  end
  
  test "get markers with bounds params" do
    # params[:bounds]="lat_lo,lng_lo,lat_hi,lng_hi"
    # box=west,south,east,north, e.g. box=-109,37,-102,41

    get :markers, {:format => 'json', :bounds => "40.0,-105.3,40.1,-105.0", :zoom => '15'}
    puts "response.body:" + response.body
    puts JSON.parse(response.body).inspect
    assert_response :success
    assert_not_equal 0, JSON.parse(response.body).size
  end
  
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:locations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create location" do
    assert_difference('Location.count') do
      post :create, :location => @location.attributes
    end

    assert_redirected_to location_path(assigns(:location))
  end

  test "should show location" do
    get :show, :id => @location.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @location.to_param
    assert_response :success
  end

  test "should update location" do
    put :update, :id => @location.to_param, :location => @location.attributes
    assert_redirected_to location_path(assigns(:location))
  end

  test "should destroy location" do
    assert_difference('Location.count', -1) do
      delete :destroy, :id => @location.to_param
    end

    assert_redirected_to locations_path
  end
end
