require 'test_helper'

class CharClassesControllerTest < ActionController::TestCase
  setup do
    @char_class = char_classes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:char_classes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create char_class" do
    assert_difference('CharClass.count') do
      post :create, :char_class => @char_class.attributes
    end

    assert_redirected_to char_class_path(assigns(:char_class))
  end

  test "should show char_class" do
    get :show, :id => @char_class.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @char_class.to_param
    assert_response :success
  end

  test "should update char_class" do
    put :update, :id => @char_class.to_param, :char_class => @char_class.attributes
    assert_redirected_to char_class_path(assigns(:char_class))
  end

  test "should destroy char_class" do
    assert_difference('CharClass.count', -1) do
      delete :destroy, :id => @char_class.to_param
    end

    assert_redirected_to char_classes_path
  end
end
