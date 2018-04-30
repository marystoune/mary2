class CreateEmailToAdmins < ActiveRecord::Migration
  def change
    create_table :email_to_admins do |t|
      t.belongs_to :account
      t.string :subject
      t.string :name
      t.text :message
      t.boolean :is_sent, default: false
      t.timestamps
    end
  end
end
