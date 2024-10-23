require "test_helper"

class PasswordControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get password_edit_url
    assert_response :success
  end
end
