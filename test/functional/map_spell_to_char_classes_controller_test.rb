require 'test_helper'

class MapSpellToCharClassesControllerTest < ActionController::TestCase
  setup do
    @map_spell_to_char_class = map_spell_to_char_classes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:map_spell_to_char_classes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create map_spell_to_char_class" do
    assert_difference('MapSpellToCharClass.count') do
      post :create, :map_spell_to_char_class => @map_spell_to_char_class.attributes
    end

    assert_redirected_to map_spell_to_char_class_path(assigns(:map_spell_to_char_class))
  end

  test "should show map_spell_to_char_class" do
    get :show, :id => @map_spell_to_char_class.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @map_spell_to_char_class.to_param
    assert_response :success
  end

  test "should update map_spell_to_char_class" do
    put :update, :id => @map_spell_to_char_class.to_param, :map_spell_to_char_class => @map_spell_to_char_class.attributes
    assert_redirected_to map_spell_to_char_class_path(assigns(:map_spell_to_char_class))
  end

  test "should destroy map_spell_to_char_class" do
    assert_difference('MapSpellToCharClass.count', -1) do
      delete :destroy, :id => @map_spell_to_char_class.to_param
    end

    assert_redirected_to map_spell_to_char_classes_path
  end
end
