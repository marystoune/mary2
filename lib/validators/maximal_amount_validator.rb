class MaximalAmountValidator < ActiveModel::EachValidator
  
  # Qiwicoins amount can't be greater than a 
  # balance on the server's wallet.
  def validate_each(record, field, value)
    qiwicoin_balance = Qiwicoin::Client.instance.getbalance

    if value && value > 0 && value > qiwicoin_balance
      record.errors[field] << I18n.t("errors.max_amount", maximum: qiwicoin_balance)
    end
  end

end
