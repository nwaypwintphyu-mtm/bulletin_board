require "test_helper"

class RegistrationControllerTest < ActionDispatch::IntegrationTest
  test "should get confirm" do
    get registration_confirm_url
    assert_response :success
  end
end
