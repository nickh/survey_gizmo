class AddAnswers < ActiveRecord::Migration
  def self.up
    create_table :answers do |t|
      t.string :blurb
      t.integer :question_id, :responder_id
    end
  end

  def self.down
    drop_table :answers
  end
end
