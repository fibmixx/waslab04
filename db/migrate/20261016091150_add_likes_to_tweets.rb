class AddLikesToTweets < ActiveRecord::Migration[8.0]
  def change
    add_column :tweets, :likes, :integer, default: 0
  end
end
