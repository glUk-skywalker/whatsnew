class CreateTesters < ActiveRecord::Migration
  def change
    create_table :testers do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false, unique: true
      t.string :phab_id, null: false, unique: true

      t.timestamps null: false
    end
  end
end
