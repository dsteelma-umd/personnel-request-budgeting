require 'test_helper'

# Integration test for the Subdepartments index page
class SubdepartmentsIndexTest < ActionDispatch::IntegrationTest
  test 'index including sorting' do
    columns = %w(code name department_code divsion_code)

    get subdepartments_path
    assert_template 'subdepartments/index'

    # Verify sort links
    assert_select 'a.sort_link', count: columns.size

    # Verify sorting
    columns.each do |column|
      %w(asc desc).each do |order|
        q_param = { s: column + ' ' + order }
        get subdepartments_path, q: q_param
        assert_template 'subdepartments/index'

        Subdepartment.ransack(q_param).result.each do |entry|
          assert_select 'a[href=?]', subdepartment_path(entry)
        end
      end
    end
  end

  test 'delete action enable status should reflect allow_delete? flag' do
    get subdepartments_path

    Subdepartment.ransack.result.each do |entry|
      assert_select 'tr[id=?]', "subdepartment_#{entry.id}"
      if entry.allow_delete?
        assert_select 'a[class~="delete"]'
      else
        assert_select 'button[class~="delete"]'
      end
    end
  end
end