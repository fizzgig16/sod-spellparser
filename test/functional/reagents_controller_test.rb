require 'test_helper'

class ReagentsControllerTest < ActionController::TestCase
  setup do
    @reagent = reagents(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:reagents)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create reagent" do
    assert_difference('Reagent.count') do
      post :create, :reagent => @reagent.attributes
    end

    assert_redirected_to reagent_path(assigns(:reagent))
  end

  test "should show reagent" do
    get :show, :id => @reagent.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @reagent.to_param
    assert_response :success
  end

  test "should update reagent" do
    put :update, :id => @reagent.to_param, :reagent => @reagent.attributes
    assert_redirected_to reagent_path(assigns(:reagent))
  end

  test "should destroy reagent" do
    assert_difference('Reagent.count', -1) do
      delete :destroy, :id => @reagent.to_param
    end

    assert_redirected_to reagents_path
  end
end
