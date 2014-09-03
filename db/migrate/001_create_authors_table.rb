class CreateAuthorsTable < ActiveRecord::Migration
  def change
    # dynamic_attributes table
    create_table :authors do |t|
        t.string  :name
        t.string  :surname
	t.integer :born_year, :null => true, :default => nil
	t.integer :death_year, :null => true, :default => nil
	t.text    :bio, :null => true, :default => nil
	t.timestamp
    end
    add_index :authors, [:name, :surname], :unique => true
    add_index :authors, :born_year
    add_index :authors, :death_year
  end 
end
