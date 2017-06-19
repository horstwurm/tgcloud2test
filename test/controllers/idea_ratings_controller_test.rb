require 'test_helper'

class IdeaRatingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @idea_rating = idea_ratings(:one)
  end

  test "should get index" do
    get idea_ratings_url
    assert_response :success
  end

  test "should get new" do
    get new_idea_rating_url
    assert_response :success
  end

  test "should create idea_rating" do
    assert_difference('IdeaRating.count') do
      post idea_ratings_url, params: { idea_rating: { criteria_id: @idea_rating.criteria_id, idea_id: @idea_rating.idea_id, rating: @idea_rating.rating, rating_text: @idea_rating.rating_text } }
    end

    assert_redirected_to idea_rating_url(IdeaRating.last)
  end

  test "should show idea_rating" do
    get idea_rating_url(@idea_rating)
    assert_response :success
  end

  test "should get edit" do
    get edit_idea_rating_url(@idea_rating)
    assert_response :success
  end

  test "should update idea_rating" do
    patch idea_rating_url(@idea_rating), params: { idea_rating: { criteria_id: @idea_rating.criteria_id, idea_id: @idea_rating.idea_id, rating: @idea_rating.rating, rating_text: @idea_rating.rating_text } }
    assert_redirected_to idea_rating_url(@idea_rating)
  end

  test "should destroy idea_rating" do
    assert_difference('IdeaRating.count', -1) do
      delete idea_rating_url(@idea_rating)
    end

    assert_redirected_to idea_ratings_url
  end
end
