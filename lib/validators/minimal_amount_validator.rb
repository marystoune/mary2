class MinimalAmountValidator < ActiveModel::EachValidator
  
  # Qiwicoins amount should not be smaller than 0 QWC.
  def validate_each(record, field, value)
    min_amount = 0.0
    
    if value && value <= min_amount
    	record.errors[field] << I18n.t("errors.min_amount", minimum: min_amount)
    end
  end

end
