require 'test_helper'

class SignagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @signage = signages(:one)
  end

  test "should get index" do
    get signages_url
    assert_response :success
  end

  test "should get new" do
    get new_signage_url
    assert_response :success
  end

  test "should create signage" do
    assert_difference('Signage.count') do
      post signages_url, params: { signage: { avatar_content_type: @signage.avatar_content_type, avatar_file_name: @signage.avatar_file_name, avatar_file_size: @signage.avatar_file_size, avatar_updated_at: @signage.avatar_updated_at, description: @signage.description, header: @signage.header, owner_id: @signage.owner_id, owner_type: @signage.owner_type, status: @signage.status } }
    end

    assert_redirected_to signage_url(Signage.last)
  end

  test "should show signage" do
    get signage_url(@signage)
    assert_response :success
  end

  test "should get edit" do
    get edit_signage_url(@signage)
    assert_response :success
  end

  test "should update signage" do
    patch signage_url(@signage), params: { signage: { avatar_content_type: @signage.avatar_content_type, avatar_file_name: @signage.avatar_file_name, avatar_file_size: @signage.avatar_file_size, avatar_updated_at: @signage.avatar_updated_at, description: @signage.description, header: @signage.header, owner_id: @signage.owner_id, owner_type: @signage.owner_type, status: @signage.status } }
    assert_redirected_to signage_url(@signage)
  end

  test "should destroy signage" do
    assert_difference('Signage.count', -1) do
      delete signage_url(@signage)
    end

    assert_redirected_to signages_url
  end
end
