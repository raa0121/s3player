require 'sinatra/base'
require 'bundler'
Bundler.require
require 'openssl'
require 'base64'
require 'net/https'
require 'rexml/document'

require 'sinatra/reloader' if development?

 class App < Sinatra::Base
 
   configure :development do
     register Sinatra::Reloader
   end
 
   configure :production, :development, :test do
     enable :logging
   end
 
   def logger
     return @logger unless @logger.nil?
     @logger = ::Logger.new($stderr)
   end
 
   def initialize *args
     init_env
     init_aws
   end
 
   def init_env
     Dotenv.load
   end
 
   def init_aws
     @s3 = Fog::Storage.new(
       provider: 'aws',
       aws_access_key_id: ENV['SAKURA_OBJECT_STORAGE_ACCESS_KEY_ID'],
       aws_secret_access_key: ENV['SAKURA_OBJECT_STORAGE_SECRET_ACCESS_KEY_ID'],
       host: 'b.sakurastorage.jp',
       endpoint: 'https://b.sakurastorage.jp',
       aws_signature_version: 2,
     )
   end
 
   get '/' do
     content_type :text
     'Still Alive'
   end
 
   get '/List' do
     content_type :json
     list = @s3.get_bucket('raa0121', delimiter: '/').body
     files = list['Contents'].map{|i| i['Key']}
     directories = list['CommonPrefixes'] 
     {Files: files, Directories: directories}.to_json
   end
 
 end

