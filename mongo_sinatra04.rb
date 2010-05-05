# -*- coding: utf-8 -*-
require 'rubygems'
require 'sinatra'
require 'mongo'
require 'active_support'
$KCODE = 'UTF8'

$limit = 20
$sort = {"value"=>1}
get '/' do
  erb :index
end
get '/suggest/1/:db' do
  content_type 'text/javascript', :charset => 'utf-8'
  @db = params[:db]
  erb :init1
end
get '/suggest/2/:db' do
  content_type 'text/javascript', :charset => 'utf-8'
  @db = params[:db]
  erb :init2
end
get '/js/:db/:key' do
  content_type 'text/javascript', :charset => 'utf-8'
  col = Mongo::Connection.new().db("mydb").collection(params[:db])
  key = "^"+params[:key]
  @db = params[:db]
  if (params[:key]=='*') then
    @json =  ActiveSupport::JSON.encode(col.find("key"=>"*").limit($limit))
  else 
    @json =  ActiveSupport::JSON.encode(col.find("key"=>/#{key}/).limit($limit))
  end
  erb :js
end

__END__

@@index
<script src="http://code.jquery.com/jquery-1.4.2.min.js"></script>
<script src="http://localhost/pmenu/suggest.js"></script>
<script src="http://localhost:4567/suggest/1/zip"></script>
<script src="http://localhost:4567/suggest/2/address"></script>
<input type='text' id='address'/>
<hr>
<input type='text' id='zip'/>

@@init1
$(document).ready(function(){ 
  $("#<%= @db %>").suggest1("<%= @db %>");
})

@@init2
$(document).ready(function(){ 
  $("#<%= @db %>").suggest2("<%= @db %>");
})

@@js
suggest.show("<%= @db %>",<%= @json %>);
