helpers do
  def root_url
    server_name = headers['SERVER_NAME'] || 'localhost:4567'
    'http://' + server_name
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
