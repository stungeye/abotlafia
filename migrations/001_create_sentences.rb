Sequel.migration do
  change do
    create_table(:sentences) do
      primary_key :id
      String    :words,     :null=>false, :size=>141
      Integer   :length,    :null=>false, :index=>true
      TrueClass :moderated, :null=>false, :index=>true, :default=>false
    end
  end
end
