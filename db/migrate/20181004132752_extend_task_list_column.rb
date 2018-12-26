class ExtendTaskListColumn < ActiveRecord::Migration
  def change
    change_column :builds, :task_list, :string, limit: 500
  end
end
