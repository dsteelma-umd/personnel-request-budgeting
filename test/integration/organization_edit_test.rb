require 'test_helper'

class OrganizationEditTest < ActionDispatch::IntegrationTest
  def setup
    use_chrome!
    login_admin
  end

  test 'should disable links when in detail page' do
    click_link 'admin'
    click_link 'Manage Organizations'

    click_link 'Administrative Services (ASD)'
    assert page.has_link?('Add Member')
    assert page.has_button?('Active')
    assert page.has_button?('Deactive')
    assert page.has_selector?('input[type=submit]:not([disabled])')

    # when we visit the nonedit page these links should not be there
    visit current_url.gsub('/edit', '')
    refute page.has_link?('Add Member')
    refute page.has_button?('Active')
    refute page.has_button?('Deactive')
    refute page.has_selector?('input[type=submit]:not([disabled])')
  end
end