class NotMineAddressValidator < ActiveModel::EachValidator
  
  # Checks an address belonging to the wallet server.
  def validate_each(record, field, value)
    unless value.blank?
      if Qiwicoin::Util.valid_qiwicoin_address?(value)
        if Qiwicoin::Util.my_qiwicoin_address?(value)
          record.errors[field] << (I18n.t "errors.is_your_address")
        end
      end
    end
  end

end
