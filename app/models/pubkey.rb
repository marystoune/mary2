class Pubkey < ActiveRecord::Base

  self.table_name = "pubkey"

  ADDRESS_VERSION = "3a"
  P2SH_VERSION = "05"

  has_many :txin_details, foreign_key: :pubkey_hash, primary_key: :pubkey_hash 
  has_many :txout_details, foreign_key: :pubkey_hash, primary_key: :pubkey_hash 

  def encoded_address
    
    tmp_pubkey_hash_new = ADDRESS_VERSION + bin_to_hex(pubkey_hash_new)
    tmp_account_k_id = bin_to_hex account_k_id
    encode_base58(tmp_pubkey_hash_new + checksum(tmp_pubkey_hash_new)) + ":" + encode_base58(tmp_account_k_id)
  end

  def self.address_in?(txin_details, address_160)
    ans = false
    txin_details.each do |txin_detail|
      ans = true if txin_detail.pubkey_hash == address_160
    end
    ans
  end

  # checksum is a 4 bytes sha256-sha256 hexdigest.
  def checksum(hex)
    b = [hex].pack("H*") # unpack hex
    Digest::SHA256.hexdigest( Digest::SHA256.digest(b) )[0...8]
  end

    def encode_base58(hex)
      leading_zero_bytes = (hex.match(/^([0]+)/) ? $1 : '').size / 2
      ("1"*leading_zero_bytes) + int_to_base58( hex.to_i(16) )
    end

    def int_to_base58(int_val, leading_zero_bytes=0)
      alpha = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
      base58_val, base = '', alpha.size
      while int_val > 0
        int_val, remainder = int_val.divmod(base)
        base58_val = alpha[remainder] + base58_val
      end
      base58_val
    end

    # get hash160 for given +address+. returns nil if address is invalid.
    def to_hash_160
     decode_base58(pubkey_hash_new)
#      return nil unless valid_address?(pubkey_hash_new)
      #decode_base58(ADDRESS_VERSION + bin_to_hex(pubkey_hash_new))#[2...42]
    end

    # check if given +address+ is valid.
    # this means having a correct version byte, length and checksum.
    def valid_address?(address)
      hex = decode_base58(address) rescue nil
      return false unless hex && hex.bytesize == 50
      return false unless [ADDRESS_VERSION, P2SH_VERSION].include?(hex[0...2])
      address_checksum?(address)
    end

    # verify base58 checksum for given +base58+ data.
    def base58_checksum?(base58)
      hex = decode_base58(base58) rescue nil
      return false unless hex
      self.checksum( hex[0...42] ) == hex[-8..-1]
    end
    alias :address_checksum? :base58_checksum?
  
  def bin_to_hex(s)
    s.unpack('H*').first
  end
end