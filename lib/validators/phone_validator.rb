class PhoneValidator < ActiveModel::EachValidator
  
  def validate_each(record, field, value)
  	country = Country.find_country_by_name(record.country)
  	cc = country.country_code

  	if !value.blank? and !Phony.plausible?(value, cc: cc)
  		record.errors[field] << (I18n.t "errors.invalid_phone_number", country: country)
  	end
  end

end
