require 'test_helper'

class SignageHitsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @signage_hit = signage_hits(:one)
  end

  test "should get index" do
    get signage_hits_url
    assert_response :success
  end

  test "should get new" do
    get new_signage_hit_url
    assert_response :success
  end

  test "should create signage_hit" do
    assert_difference('SignageHit.count') do
      post signage_hits_url, params: { signage_hit: { datetime_from: @signage_hit.datetime_from, signage_camp_id: @signage_hit.signage_camp_id, signage_loc_id: @signage_hit.signage_loc_id } }
    end

    assert_redirected_to signage_hit_url(SignageHit.last)
  end

  test "should show signage_hit" do
    get signage_hit_url(@signage_hit)
    assert_response :success
  end

  test "should get edit" do
    get edit_signage_hit_url(@signage_hit)
    assert_response :success
  end

  test "should update signage_hit" do
    patch signage_hit_url(@signage_hit), params: { signage_hit: { datetime_from: @signage_hit.datetime_from, signage_camp_id: @signage_hit.signage_camp_id, signage_loc_id: @signage_hit.signage_loc_id } }
    assert_redirected_to signage_hit_url(@signage_hit)
  end

  test "should destroy signage_hit" do
    assert_difference('SignageHit.count', -1) do
      delete signage_hit_url(@signage_hit)
    end

    assert_redirected_to signage_hits_url
  end
end
