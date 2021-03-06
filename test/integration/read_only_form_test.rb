require 'test_helper'

class ReadOnlyFormTest <  ActionDispatch::IntegrationTest

  def setup
    use_chrome!
    login_admin 
  end

  test "should have help messages on edit form but not on show" do
    click_link "New Labor Request"
    assert page.has_selector?('.help-block') 
    assert page.has_content?("Position name/title.")
    select "Faculty", from: "Employee type"
    select "New", from: "Request type"
    fill_in "Contractor name", with: SecureRandom.hex
    fill_in "Number of positions", with: 1
    fill_in "Hours per week", with: "9.99"
    fill_in "Hourly rate", with: "9.99"
    fill_in "Number of weeks", with: "9"
    select "Prange", from: "Department"
    fill_in "Justification", with: "This is a test"
    fill_in 'Position title', with: SecureRandom.hex
    click_button "Save" 
    assert page.has_content?("Labor and Assistance Requests successfully created.")
    refute page.has_selector?(".help_block") 
  end

  test "should not have help messages on archive form" do
    visit "/"
    click_link "Labor and Assistance"
    click_link "View Archive"
    first(:link, "Details").click 
    assert page.has_content?("The submission is in the archive associated to FY")
    refute page.has_selector?(".help_block") 
  end


end
