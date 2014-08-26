class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :text
      t.float :rating
      t.float :deviation
      t.float :volatility

      t.timestamps
    end
  end
end
