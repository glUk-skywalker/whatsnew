class ChangeBugListTypeToTextInBuilds < ActiveRecord::Migration
  def change
    change_column :builds, :bug_list, :text
  end
end
