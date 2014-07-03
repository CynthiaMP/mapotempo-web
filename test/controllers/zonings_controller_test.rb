require 'test_helper'

class ZoningsControllerTest < ActionController::TestCase
  set_fixture_class :delayed_jobs => Delayed::Backend::ActiveRecord::Job

  setup do
    @zoning = zonings(:zoning_one)
    sign_in users(:user_one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:zonings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create zoning" do
    assert_difference('Zoning.count') do
      post :create, zoning: { name: @zoning.name, customer: @zoning.customer }
    end

    assert_redirected_to edit_zoning_path(assigns(:zoning))
  end

  test "should show zoning" do
    get :show, id: @zoning, format: :josm
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @zoning
    assert_response :success
  end

  test "should update zoning" do
    patch :update, id: @zoning, zoning: { name: @zoning.name, customer: @zoning.customer }
    assert_redirected_to edit_zoning_path(assigns(:zoning))
  end

  test "should destroy zoning" do
    assert_difference('Zoning.count', -1) do
      delete :destroy, id: @zoning
    end

    assert_redirected_to zonings_path
  end

  test "should duplicate" do
    assert_difference('Zoning.count') do
      patch :duplicate, zoning_id: @zoning
    end

    assert_redirected_to edit_zoning_path(assigns(:zoning))
  end
end
