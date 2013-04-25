helpers do
  def root_url
    server_name = request_headers['host'] || 'localhost:4567s'
    'http://' + server_name
  end

  def request_headers
    env.inject({}){|acc, (k,v)| acc[$1.downcase] = v if k =~ /^http_(.*)/i; acc}
  end  

  # Escape URIs
  def u(text)
    URI.escape(text)
  end

  # Escape HTML
  def h(text)
    Rack::Utils.escape_html(text)
  end
end
