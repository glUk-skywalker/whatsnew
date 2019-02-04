class ExtendBugsAndTasksFields < ActiveRecord::Migration
  def change
    change_column :builds, :task_list, :string, limit: 5000
    change_column :builds, :bug_list, :string, limit: 5000
  end
end
