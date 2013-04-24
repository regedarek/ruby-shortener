%w(rubygems sinatra useragent data_mapper uri).each  { |lib| require lib}

%w(link view).each  { |model|  require_relative "models/#{model}"   }
%w(main).each       { |helper| require_relative "helpers/#{helper}" }

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/dev.db")

class Link
  include DataMapper::Resource
  has n, :views

  validates_presence_of :url,
    message: "You must specify a URL."
  validates_length_of   :url,
    maximum: 4096,
    allow_blank: true,
    message: "That URL is too long."
  validates_format_of :url,
    with: %r{^(https?|ftp)://.+}i,
    allow_blank: true,
    message: "The URL must start with http://, https://, or ftp:// ."

  property :id,         Serial
  property :url,        String
  property :token,      String
  property :created_at, DateTime
end

class View
  include DataMapper::Resource
  belongs_to :link

  property :id,         Serial
  property :link_id,    Integer
  property :browser,    String
  property :created_at, DateTime
end

DataMapper.finalize.auto_upgrade!

get '/' do
  @link = Link.new
  haml :new
end

post '/' do
  # See if it already exists
  @link = Link.first(url: params[:link][:url])
  if @link
    haml :show
  else
    # Create a new one
    @link = Link.new(params[:link])
    @link.token = rand(36**8).to_s(36)
    if @link.save
      haml :show
    else
      haml :new
    end
  end
end

# Redirect the visitor to the appropriate URL
get '/:code' do
  @link = Link.find_by_code!(params[:code])

  # Record view
  user_agent = UserAgent.parse(request.user_agent)
  View.create(
    link_id: @link.id,
    browser: user_agent.browser,
    created_at: Time.now
  )

  redirect @link.url
end

# Redirect the visitor to the URL statistics
get '/:code/stats' do
  @link = Link.find_by_code!(params[:code])
  redirect root_url unless params[:token] == @link.token
  haml :show
end
