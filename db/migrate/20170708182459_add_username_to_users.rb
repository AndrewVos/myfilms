class AddUsernameToUsers < ActiveRecord::Migration[5.1]
  def up
    add_column :users, :username, :string
    add_index :users, :username
    execute "UPDATE users SET username = regexp_replace(email, '@.*', '')"
    change_column_null :users, :username, false
  end

  def down
    remove_column :users, :username
  end
end
