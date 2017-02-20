require 'test_helper'

class SignageLocsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @signage_loc = signage_locs(:one)
  end

  test "should get index" do
    get signage_locs_url
    assert_response :success
  end

  test "should get new" do
    get new_signage_loc_url
    assert_response :success
  end

  test "should create signage_loc" do
    assert_difference('SignageLoc.count') do
      post signage_locs_url, params: { signage_loc: { address1: @signage_loc.address1, address2: @signage_loc.address2, address3: @signage_loc.address3, geo_address: @signage_loc.geo_address, owner_id: @signage_loc.owner_id, owner_type: @signage_loc.owner_type, public: @signage_loc.public, res_h: @signage_loc.res_h, res_v: @signage_loc.res_v, status: @signage_loc.status } }
    end

    assert_redirected_to signage_loc_url(SignageLoc.last)
  end

  test "should show signage_loc" do
    get signage_loc_url(@signage_loc)
    assert_response :success
  end

  test "should get edit" do
    get edit_signage_loc_url(@signage_loc)
    assert_response :success
  end

  test "should update signage_loc" do
    patch signage_loc_url(@signage_loc), params: { signage_loc: { address1: @signage_loc.address1, address2: @signage_loc.address2, address3: @signage_loc.address3, geo_address: @signage_loc.geo_address, owner_id: @signage_loc.owner_id, owner_type: @signage_loc.owner_type, public: @signage_loc.public, res_h: @signage_loc.res_h, res_v: @signage_loc.res_v, status: @signage_loc.status } }
    assert_redirected_to signage_loc_url(@signage_loc)
  end

  test "should destroy signage_loc" do
    assert_difference('SignageLoc.count', -1) do
      delete signage_loc_url(@signage_loc)
    end

    assert_redirected_to signage_locs_url
  end
end
