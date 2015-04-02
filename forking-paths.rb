require 'sinatra/base'
require 'liquid'
require 'kramdown'
require 'yaml'


configure do
  set :markdown_engine, :kramdown
  set :markdown, :layout_engine => :liquid, 
                 :tables => true, 
                 :autolink => true,
                 :smartypants => true
  Liquid::Template.file_system = Liquid::LocalFileSystem.new(File.join(File.dirname(__FILE__),'views/includes'))
end


class ForkingPaths < Sinatra::Application


  def get_yaml(path)
    headers = File.exists?(path) ? YAML.load_file(path) : {"title" => "not found"}
    headers["slug"] = File.split(path)[0].split("/")[-1]
    headers["title"] = kram_it(headers["title"])
    return headers
  end

  get '/' do
    src = "lee.md"
    text = File.read(src)
    headers = YAML.load(text)
    body = text.split(/^---$/)[2]
    liquid :main, :locals => {:headers => headers,:body => markdown(body), :md_name => src}
  end

  post '/edit' do
    src = "lee.md"
    selection = params['selection']
    text = File.read(src)
    text = selection + "\n\n" + text
    liquid :edit, :locals => {:headers => headers,:body => text, :md_name => src}
  end


end
