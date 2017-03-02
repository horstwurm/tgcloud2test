require 'test_helper'

class QrcodesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @qrcode = qrcodes(:one)
  end

  test "should get index" do
    get qrcodes_url
    assert_response :success
  end

  test "should get new" do
    get new_qrcode_url
    assert_response :success
  end

  test "should create qrcode" do
    assert_difference('Qrcode.count') do
      post qrcodes_url, params: { qrcode: { avatar_content_type: @qrcode.avatar_content_type, avatar_file_name: @qrcode.avatar_file_name, avatar_file_size: @qrcode.avatar_file_size, avatar_updated_at: @qrcode.avatar_updated_at, mobject_id: @qrcode.mobject_id, mobject_type: @qrcode.mobject_type } }
    end

    assert_redirected_to qrcode_url(Qrcode.last)
  end

  test "should show qrcode" do
    get qrcode_url(@qrcode)
    assert_response :success
  end

  test "should get edit" do
    get edit_qrcode_url(@qrcode)
    assert_response :success
  end

  test "should update qrcode" do
    patch qrcode_url(@qrcode), params: { qrcode: { avatar_content_type: @qrcode.avatar_content_type, avatar_file_name: @qrcode.avatar_file_name, avatar_file_size: @qrcode.avatar_file_size, avatar_updated_at: @qrcode.avatar_updated_at, mobject_id: @qrcode.mobject_id, mobject_type: @qrcode.mobject_type } }
    assert_redirected_to qrcode_url(@qrcode)
  end

  test "should destroy qrcode" do
    assert_difference('Qrcode.count', -1) do
      delete qrcode_url(@qrcode)
    end

    assert_redirected_to qrcodes_url
  end
end
