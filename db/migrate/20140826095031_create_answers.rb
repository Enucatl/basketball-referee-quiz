class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.text :text
      t.boolean :is_correct?

      t.timestamps
    end
  end
end
