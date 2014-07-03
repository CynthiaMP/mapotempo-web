require 'test_helper'

class TagsControllerTest < ActionController::TestCase
  set_fixture_class :delayed_jobs => Delayed::Backend::ActiveRecord::Job

  setup do
    @tag = tags(:tag_one)
    sign_in users(:user_one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tags)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tag" do
    assert_difference('Tag.count') do
      post :create, tag: { label: @tag.label, customer: @tag.customer }
    end

    assert_redirected_to tags_path
  end

  test "should get edit" do
    get :edit, id: @tag
    assert_response :success
  end

  test "should update tag" do
    patch :update, id: @tag, tag: { label: @tag.label, customer: @tag.customer }
    assert_redirected_to tags_path
  end

  test "should destroy tag" do
    assert_difference('Tag.count', -1) do
      delete :destroy, id: @tag
    end

    assert_redirected_to tags_path
  end
end
