class AddBreakOnSuccessToUsers < ActiveRecord::Migration
  def change
    add_column :users, :break_on_success, :boolean
  end
end
