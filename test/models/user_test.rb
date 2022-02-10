require "test_helper"

class UserTest < ActiveSupport::TestCase

  test "Happy Case" do
    user = User.new(employee_number: '1234', password: 'P' * User::MINIMUM_PASSWORD_LENGTH, role: User::ROLE_EMPLOYEE)
    assert_equal(user.valid?, true)
  end

  test "Invalid Roles" do
    user = User.new(employee_number: '1234', password: 'P' * User::MINIMUM_PASSWORD_LENGTH, role: "INVALID")
    assert_equal(user.valid?, false)
    assert_equal(user.errors.messages.keys.include?(:role), true)
  end

  test "Invalid Password length" do
    user = User.new(employee_number: '1234', password: 'P' * (User::MINIMUM_PASSWORD_LENGTH - 1), role: User::ROLE_EMPLOYEE)
    assert_equal(user.valid?, false)
    assert_equal(user.errors.messages.keys.include?(:password), true)
  end

  test "Employee number uniqueness" do
    User.create(employee_number: '1234', password: 'P' * User::MINIMUM_PASSWORD_LENGTH, role: User::ROLE_EMPLOYEE)
    user = User.new(employee_number: '1234', password: 'P' * User::MINIMUM_PASSWORD_LENGTH, role: User::ROLE_EMPLOYEE)
    assert_equal(user.valid?, false)
    assert_equal(user.errors.messages.keys.include?(:employee_number), true)
  end

  test "Employee number 4 digit numeric" do
    user = User.new(employee_number: 'invalid', password: 'P' * User::MINIMUM_PASSWORD_LENGTH, role: User::ROLE_EMPLOYEE)
    assert_equal(user.valid?, false)
    assert_equal(user.errors.messages.keys.include?(:employee_number), true)

    user = User.new(employee_number: '123A', password: 'P' * User::MINIMUM_PASSWORD_LENGTH, role: User::ROLE_EMPLOYEE)
    assert_equal(user.valid?, false)
    assert_equal(user.errors.messages.keys.include?(:employee_number), true)
  end

end
