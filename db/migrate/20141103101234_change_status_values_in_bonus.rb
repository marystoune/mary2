class ChangeStatusValuesInBonus < ActiveRecord::Migration
  def self.up
    Bonus.all.each do |bonus|
      bonus.status = bonus.is_sended ? 'paid' : 'pending'
      bonus.save(validate: false)
    end
  end

  def self.down
    Bonus.all.each do |bonus|
      bonus.status = nil
      bonus.save(validate: false)
    end
  end
end
