require 'test_helper'

class IdeaCrowdratingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @idea_crowdrating = idea_crowdratings(:one)
  end

  test "should get index" do
    get idea_crowdratings_url
    assert_response :success
  end

  test "should get new" do
    get new_idea_crowdrating_url
    assert_response :success
  end

  test "should create idea_crowdrating" do
    assert_difference('IdeaCrowdrating.count') do
      post idea_crowdratings_url, params: { idea_crowdrating: { idea_id: @idea_crowdrating.idea_id, rating: @idea_crowdrating.rating, rating_text: @idea_crowdrating.rating_text, user_id: @idea_crowdrating.user_id } }
    end

    assert_redirected_to idea_crowdrating_url(IdeaCrowdrating.last)
  end

  test "should show idea_crowdrating" do
    get idea_crowdrating_url(@idea_crowdrating)
    assert_response :success
  end

  test "should get edit" do
    get edit_idea_crowdrating_url(@idea_crowdrating)
    assert_response :success
  end

  test "should update idea_crowdrating" do
    patch idea_crowdrating_url(@idea_crowdrating), params: { idea_crowdrating: { idea_id: @idea_crowdrating.idea_id, rating: @idea_crowdrating.rating, rating_text: @idea_crowdrating.rating_text, user_id: @idea_crowdrating.user_id } }
    assert_redirected_to idea_crowdrating_url(@idea_crowdrating)
  end

  test "should destroy idea_crowdrating" do
    assert_difference('IdeaCrowdrating.count', -1) do
      delete idea_crowdrating_url(@idea_crowdrating)
    end

    assert_redirected_to idea_crowdratings_url
  end
end
