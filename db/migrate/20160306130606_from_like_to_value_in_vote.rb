class FromLikeToValueInVote < ActiveRecord::Migration
  def change
    rename_column :votes, :like, :value
  end
end
