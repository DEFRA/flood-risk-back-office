class AddEnrollmentExports < ActiveRecord::Migration[4.2]
  def change
    create_table :enrollment_exports do |t|
      t.date :from_date, null: false
      t.date :to_date, null: false
      t.string :created_by, null: false

      t.string :file_name, null: false
      t.index :file_name, unique: true

      t.integer :state, null: false, default: 0
      t.text :failure_text

      t.integer :record_count

      t.timestamps null: false
      t.index :created_at
    end
  end
end
