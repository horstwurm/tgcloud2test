require 'test_helper'

class DataloadersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @dataloader = dataloaders(:one)
  end

  test "should get index" do
    get dataloaders_url
    assert_response :success
  end

  test "should get new" do
    get new_dataloader_url
    assert_response :success
  end

  test "should create dataloader" do
    assert_difference('Dataloader.count') do
      post dataloaders_url, params: { dataloader: { mcategory_id: @dataloader.mcategory_id, name: @dataloader.name } }
    end

    assert_redirected_to dataloader_url(Dataloader.last)
  end

  test "should show dataloader" do
    get dataloader_url(@dataloader)
    assert_response :success
  end

  test "should get edit" do
    get edit_dataloader_url(@dataloader)
    assert_response :success
  end

  test "should update dataloader" do
    patch dataloader_url(@dataloader), params: { dataloader: { mcategory_id: @dataloader.mcategory_id, name: @dataloader.name } }
    assert_redirected_to dataloader_url(@dataloader)
  end

  test "should destroy dataloader" do
    assert_difference('Dataloader.count', -1) do
      delete dataloader_url(@dataloader)
    end

    assert_redirected_to dataloaders_url
  end
end
