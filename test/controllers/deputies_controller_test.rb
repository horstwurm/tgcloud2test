require 'test_helper'

class DeputiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @deputy = deputies(:one)
  end

  test "should get index" do
    get deputies_url
    assert_response :success
  end

  test "should get new" do
    get new_deputy_url
    assert_response :success
  end

  test "should create deputy" do
    assert_difference('Deputy.count') do
      post deputies_url, params: { deputy: { date_from: @deputy.date_from, date_to: @deputy.date_to, owner_id: @deputy.owner_id, owner_type: @deputy.owner_type, user_id: @deputy.user_id } }
    end

    assert_redirected_to deputy_url(Deputy.last)
  end

  test "should show deputy" do
    get deputy_url(@deputy)
    assert_response :success
  end

  test "should get edit" do
    get edit_deputy_url(@deputy)
    assert_response :success
  end

  test "should update deputy" do
    patch deputy_url(@deputy), params: { deputy: { date_from: @deputy.date_from, date_to: @deputy.date_to, owner_id: @deputy.owner_id, owner_type: @deputy.owner_type, user_id: @deputy.user_id } }
    assert_redirected_to deputy_url(@deputy)
  end

  test "should destroy deputy" do
    assert_difference('Deputy.count', -1) do
      delete deputy_url(@deputy)
    end

    assert_redirected_to deputies_url
  end
end
