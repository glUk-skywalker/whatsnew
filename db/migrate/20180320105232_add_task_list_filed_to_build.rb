class AddTaskListFiledToBuild < ActiveRecord::Migration
  def change
    add_column :builds, :task_list, :string
  end
end
