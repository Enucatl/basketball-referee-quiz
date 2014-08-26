class AddTagToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :tag, :text
  end
end
