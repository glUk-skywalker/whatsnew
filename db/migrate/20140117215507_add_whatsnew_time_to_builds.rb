class AddWhatsnewTimeToBuilds < ActiveRecord::Migration
  def change
    add_column :builds, :whatsnew_time, :datetime
  end
end
