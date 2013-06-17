# encoding: utf-8
class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :title
      t.text :content
    end
    Contact.create!(:title=>"联系我们", :content=>"请更改内容")
    Contact.create!(:title=>"关于我们", :content=>"请更改内容")
  end
end
