Sequel.migration do
  change do
    alter_table(:sentences) do
      add_column :tweeted, TrueClass, :null=>false, :default=>false
      add_index :tweeted
    end
  end
end
