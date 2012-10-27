require 'test_helper'

class TargetTypesControllerTest < ActionController::TestCase
  setup do
    @target_type = target_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:target_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create target_type" do
    assert_difference('TargetType.count') do
      post :create, :target_type => @target_type.attributes
    end

    assert_redirected_to target_type_path(assigns(:target_type))
  end

  test "should show target_type" do
    get :show, :id => @target_type.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @target_type.to_param
    assert_response :success
  end

  test "should update target_type" do
    put :update, :id => @target_type.to_param, :target_type => @target_type.attributes
    assert_redirected_to target_type_path(assigns(:target_type))
  end

  test "should destroy target_type" do
    assert_difference('TargetType.count', -1) do
      delete :destroy, :id => @target_type.to_param
    end

    assert_redirected_to target_types_path
  end
end
