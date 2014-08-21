class AddProcessedToBuilds < ActiveRecord::Migration
  def change
    add_column :builds, :processed, :boolean, default: false
  end
end
