require 'test_helper'

class SignageCalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @signage_cal = signage_cals(:one)
  end

  test "should get index" do
    get signage_cals_url
    assert_response :success
  end

  test "should get new" do
    get new_signage_cal_url
    assert_response :success
  end

  test "should create signage_cal" do
    assert_difference('SignageCal.count') do
      post signage_cals_url, params: { signage_cal: { date_from: @signage_cal.date_from, date_to: @signage_cal.date_to, signage_id: @signage_cal.signage_id, signage_loc_id: @signage_cal.signage_loc_id, time_from: @signage_cal.time_from, time_to: @signage_cal.time_to } }
    end

    assert_redirected_to signage_cal_url(SignageCal.last)
  end

  test "should show signage_cal" do
    get signage_cal_url(@signage_cal)
    assert_response :success
  end

  test "should get edit" do
    get edit_signage_cal_url(@signage_cal)
    assert_response :success
  end

  test "should update signage_cal" do
    patch signage_cal_url(@signage_cal), params: { signage_cal: { date_from: @signage_cal.date_from, date_to: @signage_cal.date_to, signage_id: @signage_cal.signage_id, signage_loc_id: @signage_cal.signage_loc_id, time_from: @signage_cal.time_from, time_to: @signage_cal.time_to } }
    assert_redirected_to signage_cal_url(@signage_cal)
  end

  test "should destroy signage_cal" do
    assert_difference('SignageCal.count', -1) do
      delete signage_cal_url(@signage_cal)
    end

    assert_redirected_to signage_cals_url
  end
end
