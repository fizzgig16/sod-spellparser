require 'test_helper'

class ZoneTypesControllerTest < ActionController::TestCase
  setup do
    @zone_type = zone_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:zone_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create zone_type" do
    assert_difference('ZoneType.count') do
      post :create, :zone_type => @zone_type.attributes
    end

    assert_redirected_to zone_type_path(assigns(:zone_type))
  end

  test "should show zone_type" do
    get :show, :id => @zone_type.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @zone_type.to_param
    assert_response :success
  end

  test "should update zone_type" do
    put :update, :id => @zone_type.to_param, :zone_type => @zone_type.attributes
    assert_redirected_to zone_type_path(assigns(:zone_type))
  end

  test "should destroy zone_type" do
    assert_difference('ZoneType.count', -1) do
      delete :destroy, :id => @zone_type.to_param
    end

    assert_redirected_to zone_types_path
  end
end
