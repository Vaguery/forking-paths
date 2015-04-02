require 'sinatra/base'

class ForkingPaths < Sinatra::Base
  get '/' do
    'Fork this particular thing right here.'
  end
end
