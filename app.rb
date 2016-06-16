require 'rubygems'
require 'sinatra'
require 'data_mapper' # metagem, requires common plugins too.

# need install dm-sqlite-adapter
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/blog.db")

class Post
  include DataMapper::Resource
  property :id, Serial
  property :title, String
  property :body, Text
  property :created_at, DateTime
end

# Perform basic sanity checks and initialize all relationships
# Call this when you've defined all your models
DataMapper.finalize

# automatically create the post table
Post.auto_upgrade!

get '/' do
  # get the latest 20 posts
  @posts = Post.all(:order => [ :id.desc ], :limit => 20)
  erb :index
end

get '/' do
  erb :index
end

get '/posts' do
  @posts = Post.all
  erb :'posts/index'
end

get '/posts/new' do
  erb :'posts/new'
end

get '/posts/:id' do |id|
  @post = Post.get!(id)
  erb :'posts/show'
end

get '/posts/:id/edit' do |id|
  @post = Post.get!(id)
  erb :'posts/edit'
end

post '/posts' do
  post = Post.new(params[:post])
  
  if post.save
    redirect '/posts'
  else
    redirect '/posts/new'
  end
end

put '/posts/:id' do |id|
  post = Post.get!(id)
  success = post.update!(params[:post])
  
  if success
    redirect "/posts/#{id}"
  else
    redirect "/posts/#{id}/edit"
  end
end

delete '/posts/:id' do |id|
  post = Post.get!(id)
  post.destroy!
  redirect "/posts"
end