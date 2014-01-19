class AddBugListColumnToBuilds < ActiveRecord::Migration
  def change
    add_column :builds, :bug_list, :string
  end
end
