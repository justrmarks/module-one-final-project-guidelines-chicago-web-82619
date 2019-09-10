class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.string :ts
      t.string :text
      t.string :user_slack_id
      t.string :channel_slack_id
    end
  end
end
