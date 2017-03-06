require 'test_helper'

class EditionArcticlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @edition_arcticle = edition_arcticles(:one)
  end

  test "should get index" do
    get edition_arcticles_url
    assert_response :success
  end

  test "should get new" do
    get new_edition_arcticle_url
    assert_response :success
  end

  test "should create edition_arcticle" do
    assert_difference('EditionArcticle.count') do
      post edition_arcticles_url, params: { edition_arcticle: { article_id: @edition_arcticle.article_id, edition_id: @edition_arcticle.edition_id, status: @edition_arcticle.status } }
    end

    assert_redirected_to edition_arcticle_url(EditionArcticle.last)
  end

  test "should show edition_arcticle" do
    get edition_arcticle_url(@edition_arcticle)
    assert_response :success
  end

  test "should get edit" do
    get edit_edition_arcticle_url(@edition_arcticle)
    assert_response :success
  end

  test "should update edition_arcticle" do
    patch edition_arcticle_url(@edition_arcticle), params: { edition_arcticle: { article_id: @edition_arcticle.article_id, edition_id: @edition_arcticle.edition_id, status: @edition_arcticle.status } }
    assert_redirected_to edition_arcticle_url(@edition_arcticle)
  end

  test "should destroy edition_arcticle" do
    assert_difference('EditionArcticle.count', -1) do
      delete edition_arcticle_url(@edition_arcticle)
    end

    assert_redirected_to edition_arcticles_url
  end
end
