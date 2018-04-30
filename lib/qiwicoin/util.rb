module Qiwicoin
  module Util
    def self.valid_qiwicoin_address?(address)
      # We don't want leading/trailing spaces to pollute addresses
      (address == address.strip) and Qiwicoin::Client.instance.validate_address(address)['isvalid']
    end

    def self.my_qiwicoin_address?(address)
      Qiwicoin::Client.instance.validate_address(address)['ismine']
    end

    def self.get_account(address)
      Qiwicoin::Client.instance.get_account(address)
    end
  end
end
