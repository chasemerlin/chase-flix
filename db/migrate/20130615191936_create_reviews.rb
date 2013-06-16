class CreateReviews < ActiveRecord::Migration
  def up
  	create_table :reviews do |t|
  		t.integer :rating
  		t.integer :user_id
  		t.integer :video_id
  		t.text :description
  		t.timestamps
  	end
  end

  def down
  	drop_table :reviews 
  end
end
