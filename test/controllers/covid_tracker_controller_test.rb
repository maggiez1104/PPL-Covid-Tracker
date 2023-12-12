require "test_helper"

class CovidTrackerControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get covid_tracker_index_url
    assert_response :success
  end
end
