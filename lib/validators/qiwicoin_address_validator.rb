class QiwicoinAddressValidator < ActiveModel::EachValidator

  # Checks validity of a qiwicoin address.
  def validate_each(record, field, value)
    unless (value.blank? or Qiwicoin::Util.valid_qiwicoin_address?(value))
      record.errors[field] << (I18n.t "errors.invalid")
    end
  end

end
