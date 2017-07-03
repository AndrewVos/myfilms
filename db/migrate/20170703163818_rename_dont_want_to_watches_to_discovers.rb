class RenameDontWantToWatchesToDiscovers < ActiveRecord::Migration[5.1]
  def change
    rename_table :dont_want_to_watches, :discovers
  end
end
