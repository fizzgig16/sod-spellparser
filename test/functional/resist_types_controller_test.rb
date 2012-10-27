require 'test_helper'

class ResistTypesControllerTest < ActionController::TestCase
  setup do
    @resist_type = resist_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:resist_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create resist_type" do
    assert_difference('ResistType.count') do
      post :create, :resist_type => @resist_type.attributes
    end

    assert_redirected_to resist_type_path(assigns(:resist_type))
  end

  test "should show resist_type" do
    get :show, :id => @resist_type.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @resist_type.to_param
    assert_response :success
  end

  test "should update resist_type" do
    put :update, :id => @resist_type.to_param, :resist_type => @resist_type.attributes
    assert_redirected_to resist_type_path(assigns(:resist_type))
  end

  test "should destroy resist_type" do
    assert_difference('ResistType.count', -1) do
      delete :destroy, :id => @resist_type.to_param
    end

    assert_redirected_to resist_types_path
  end
end
