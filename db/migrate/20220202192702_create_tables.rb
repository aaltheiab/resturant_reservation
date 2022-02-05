class CreateTables < ActiveRecord::Migration[6.1]
  def change
    create_table :tables do |t|
      t.integer :number
      t.integer :number_of_seats
      t.timestamps
    end
  end
end
