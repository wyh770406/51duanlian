# encoding: utf-8
class UserAgreements < ActiveRecord::Migration
  def change
    create_table :user_agreements do |t|
      t.string :title
      t.text :content
    end
    UserAgreement.create!(:title=>"网络用户协议", :content=>"请更改协议内容")
    UserAgreement.create!(:title=>"场馆用户服务协议", :content=>"请更改协议内容")
  end
end
