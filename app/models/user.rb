class User < ApplicationRecord
  MAX_EMPLOYEE_NUMBER_LENGTH = 4
  MINIMUM_PASSWORD_LENGTH = 6
  ROLE_ADMIN = 'ADMIN'
  ROLE_EMPLOYEE = 'EMPLOYEE'
  ROLES = [ROLE_ADMIN, ROLE_EMPLOYEE]

  has_secure_password
  validates :password, length: { minimum: MINIMUM_PASSWORD_LENGTH }, if: -> { new_record? || !password.nil? }
  validates :employee_number, presence: true, uniqueness: true, numericality: { only_integer: true },
            length: { is: MAX_EMPLOYEE_NUMBER_LENGTH }
  validates :role, presence: true, inclusion: { in: ROLES }

  def admin?
    role == ROLE_ADMIN
  end
end
