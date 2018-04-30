# encoding: utf-8
class Search

	METHODS = %w(transaction address block)
	
	def initialize(search_condition)
		@condition = search_condition.strip
	end
	

	def result

		return @path = "/blockchain" if @condition.blank?

		METHODS.each do |method|
			@path = Search.send(method, @condition)
			return @path if @path
		end

		@path = Search.default
	end

	def self.transaction(condition)
		tx = Tx.where("tx_hash = ?", hex_to_bin(condition)).first
		return tx ? "/blockchain/tx/#{tx.id}" : nil
	end

	def self.block(condition)
			res = Block.where("block_height = ?", condition).first
			return res && res.block_height != 0 ? "/blockchain/block/#{res.block_height}" : nil
	end

	def self.address(condition)
		condition_account_k_id = hex_to_bin(decode_base58(condition))
		condition_pubkey_hash_new = hex_to_bin(decode_base58(condition)[2,40])
		#p condition_pubkey_hash_new
		res = nil
		begin
			res = Pubkey.where("pubkey_hash_new = ? or account_k_id = ?", condition_pubkey_hash_new, condition_account_k_id).first
                        #return !res ? nil : "/blockchain/address/#{res.id}"
                        if condition[":"]
                          parts = condition.split(/:/)
                          condition_account_k_id = hex_to_bin(decode_base58(parts[1]))
                          condition_pubkey_hash_new = hex_to_bin(decode_base58(parts[0])[2,40])	
			  #p condition_pubkey_hash_new
                          res = Pubkey.where(pubkey_hash_new: condition_pubkey_hash_new)
                          res = res.where(account_k_id: condition_account_k_id).first
                        end
		rescue
		end
		!res ? nil : "/blockchain/address/#{res.id}"
	end

	def self.default
		"/blockchain"
	end

  def self.bin_to_hex(s)
    s.unpack('H*').first
  end

  def self.hex_to_bin(s)
    s.scan(/../).map { |x| x.hex }.pack('c*')
  end

    def self.decode_base58(base58_val)
      s = base58_to_int(base58_val).to_s(16); s = (s.bytesize.odd? ? '0'+s : s)
      s = '' if s == '3a'
      leading_zero_bytes = (base58_val.match(/^([1]+)/) ? $1 : '').size
      s = ("3a"*leading_zero_bytes) + s if leading_zero_bytes > 0
      s
    end

    def self.base58_to_int(base58_val)
      alpha = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
      int_val, base = 0, alpha.size
      base58_val.reverse.each_char.with_index do |char,index|
        begin
        char_index = alpha.index(char)
        int_val += char_index*(base**index)
      	rescue
      	end
      end
      int_val
    end



end
