class AddPhotoToUser < ActiveRecord::Migration
  def change
    add_attachment :users, :photo # Photo upload to user
  end
end
