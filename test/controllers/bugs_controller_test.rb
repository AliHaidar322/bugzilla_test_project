require "test_helper"

class BugsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get bugs_index_url
    assert_response :success
  end

  test "should get new" do
    get bugs_new_url
    assert_response :success
  end

  test "should get create" do
    get bugs_create_url
    assert_response :success
  end
end
