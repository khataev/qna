module ApiHelpers
  def send_request(type, url, options = {})
    send type, url, options.merge(format: :json)
  end
end
