class AddBreakOnFailureToUsers < ActiveRecord::Migration
  def change
    add_column :users, :break_on_failure, :boolean
  end
end
