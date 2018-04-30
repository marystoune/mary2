class PositiveValidator < ActiveModel::EachValidator
  
  # Сhecks whether a number is positive.
  def validate_each(record, field, value)
    if value && value < 0
      record.errors[field] << I18n.t("errors.should_be_positive")
    end
  end

end
