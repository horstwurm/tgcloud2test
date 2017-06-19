require 'test_helper'

class CritsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @crit = crits(:one)
  end

  test "should get index" do
    get crits_url
    assert_response :success
  end

  test "should get new" do
    get new_crit_url
    assert_response :success
  end

  test "should create crit" do
    assert_difference('Crit.count') do
      post crits_url, params: { crit: { mobject_id: @crit.mobject_id } }
    end

    assert_redirected_to crit_url(Crit.last)
  end

  test "should show crit" do
    get crit_url(@crit)
    assert_response :success
  end

  test "should get edit" do
    get edit_crit_url(@crit)
    assert_response :success
  end

  test "should update crit" do
    patch crit_url(@crit), params: { crit: { mobject_id: @crit.mobject_id } }
    assert_redirected_to crit_url(@crit)
  end

  test "should destroy crit" do
    assert_difference('Crit.count', -1) do
      delete crit_url(@crit)
    end

    assert_redirected_to crits_url
  end
end
