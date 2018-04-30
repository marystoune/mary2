class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
    	t.integer :account_id
    	t.string  :code
    	t.integer :attempt_count, default: 0
    	t.string  :message_id
    	t.boolean :is_sended, default: false

      t.timestamps
    end
  end
end
