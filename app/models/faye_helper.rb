class FayeHelper

  NAME_FOR_PARAM = 'message'
  USE_SSL = true
  URI_FAYE = "https://www.qiwicoin.org/faye"

  def initialize(channel, data)
    @message = {}
    @message[:data] = data
    @message[:channel] = channel
    @message[:ext] = { auth_token: FAYE_TOKEN }
  end

  def broadcast
    @uri = URI.parse(URI_FAYE)
    https = Net::HTTP.new(@uri.host,@uri.port)
    https.use_ssl = USE_SSL
    https.verify_mode = OpenSSL::SSL::VERIFY_NONE
    req = Net::HTTP::Post.new(@uri.path)
    req.set_form_data NAME_FOR_PARAM => @message.to_json
    https.request(req)
  end

end
