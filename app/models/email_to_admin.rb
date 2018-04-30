class EmailToAdmin < ActiveRecord::Base

  belongs_to :account
  delegate :email, to: :account


  validates :account, presence: true
  validates :subject, presence: true, length: { maximum: 200 }
  validates :name, presence: true, length: { maximum: 200 }
  validates :message, presence: true, length: { maximum: 2000 }

end
