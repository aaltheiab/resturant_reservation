class CreateReservations < ActiveRecord::Migration[6.1]
  def change
    create_table :reservations do |t|
      t.datetime :start_at
      t.datetime :end_at
      t.string :customer_name
      t.references :table, foreign_key: true, index: true
      t.integer :seats
      t.timestamps
    end
  end
end
