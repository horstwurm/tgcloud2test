require 'test_helper'

class MlikesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mlike = mlikes(:one)
  end

  test "should get index" do
    get mlikes_url
    assert_response :success
  end

  test "should get new" do
    get new_mlike_url
    assert_response :success
  end

  test "should create mlike" do
    assert_difference('Mlike.count') do
      post mlikes_url, params: { mlike: { like: @mlike.like, mobject_id: @mlike.mobject_id, user_id: @mlike.user_id } }
    end

    assert_redirected_to mlike_url(Mlike.last)
  end

  test "should show mlike" do
    get mlike_url(@mlike)
    assert_response :success
  end

  test "should get edit" do
    get edit_mlike_url(@mlike)
    assert_response :success
  end

  test "should update mlike" do
    patch mlike_url(@mlike), params: { mlike: { like: @mlike.like, mobject_id: @mlike.mobject_id, user_id: @mlike.user_id } }
    assert_redirected_to mlike_url(@mlike)
  end

  test "should destroy mlike" do
    assert_difference('Mlike.count', -1) do
      delete mlike_url(@mlike)
    end

    assert_redirected_to mlikes_url
  end
end
