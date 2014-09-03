class CreateTalesTable < ActiveRecord::Migration
  def change
    create_table :tales do |t|
      t.string  :title
    	t.text :text, :limit => 4294967295
    	t.date :published_date, :null => true, :dafult => nil
    	t.timestamp
    end
    add_index :tales, :title
    add_index :tales, :published_date

    create_table :authors_tales, id: false do |t|
      t.belongs_to :author
      t.belongs_to :tale
    end
  end 
end
