require 'test_helper'

class SignageCampsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @signage_camp = signage_camps(:one)
  end

  test "should get index" do
    get signage_camps_url
    assert_response :success
  end

  test "should get new" do
    get new_signage_camp_url
    assert_response :success
  end

  test "should create signage_camp" do
    assert_difference('SignageCamp.count') do
      post signage_camps_url, params: { signage_camp: { owner_id: @signage_camp.owner_id, owner_type: @signage_camp.owner_type } }
    end

    assert_redirected_to signage_camp_url(SignageCamp.last)
  end

  test "should show signage_camp" do
    get signage_camp_url(@signage_camp)
    assert_response :success
  end

  test "should get edit" do
    get edit_signage_camp_url(@signage_camp)
    assert_response :success
  end

  test "should update signage_camp" do
    patch signage_camp_url(@signage_camp), params: { signage_camp: { owner_id: @signage_camp.owner_id, owner_type: @signage_camp.owner_type } }
    assert_redirected_to signage_camp_url(@signage_camp)
  end

  test "should destroy signage_camp" do
    assert_difference('SignageCamp.count', -1) do
      delete signage_camp_url(@signage_camp)
    end

    assert_redirected_to signage_camps_url
  end
end
