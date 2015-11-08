class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :encrypted_password

      # Person
      t.string :name
      t.datetime :registered_on

      t.string :client_id
      t.string :client_type

      t.belongs_to :person

      t.timestamps null: false
    end
  end
end
