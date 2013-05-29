class AddMobileVerificationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mobile_verification_code, :string
    add_column :users, :mobile_verified_at, :datetime

    add_index :users, :mobile
    add_index :users, :mobile_verified_at
  end
end
