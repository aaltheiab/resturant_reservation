class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :password_digest
      t.string :name
      t.string :employee_number
      t.string :role

      t.timestamps
    end
  end
end
