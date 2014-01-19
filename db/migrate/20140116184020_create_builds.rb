class CreateBuilds < ActiveRecord::Migration
  def change
    create_table :builds do |t|
      t.string :number
      t.string :tag

      t.timestamps
    end
  end
end
