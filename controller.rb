#!/usr/bin/env ruby
require 'yaml'
require 'net/http'

db = YAML.load(File.read("db.yml"))

@host = db["host"]
@port = db["port"]
@auth = db["authtoken"]
@http = Net::HTTP.new(@host, @port)

init_uri = URI("http://#{@host}:#{@port}/status")
init_req = Net::HTTP::Get.new(init_uri)
init_req['X-ZT1-Auth'] = @auth
init_res = @http.request(init_req)
@zt_host_id = init_res.body.match(/(?<="address": ")[a-zA-Z0-9]+/)[0]

def get_stats
   uri = URI("http://#{@host}:#{@port}/status")
   req = Net::HTTP::Get.new(uri)
   req['X-ZT1-Auth'] = @auth
   res = @http.request(req)
   puts res.body + "\n"
end

def get_ctrl_stats
   uri = URI("http://#{@host}:#{@port}/controller")
   req = Net::HTTP::Get.new(uri)
   req['X-ZT1-Auth'] = @auth
   res = @http.request(req)
   puts res.body + "\n"
end

def get_nets
   uri = URI("http://#{@host}:#{@port}/controller/network")
   req = Net::HTTP::Get.new(uri)
   req['X-ZT1-Auth'] = @auth
   res = @http.request(req)
   puts res.body + "\n\n"
end

def post_create_net
   uri = URI("http://#{@host}:#{@port}/controller/network/#{@zt_host_id}______")
   req = Net::HTTP::Post.new(uri, 'name' => "test123")
   req['X-ZT1-Auth'] = @auth
   req.body = '{}'
   res = @http.request(req)
   puts res.body + "\n\n"
end

puts "Welcome to zt1rb2, host is <#{@zt_host_id}>"

select = 0
while (select !=9)
   printf(">====[ zt1rb2 ]====<\n")
   printf("1) list networks\n2) create new network\n")
   printf("7) stats - host\n8) stats - controller\n")
   printf("9) to exit: ")
   select = gets.chomp.to_i

   if (select == 1)
      get_nets()
   elsif (select == 2)
      post_create_net()
   elsif (select == 7)
      get_stats()
   elsif (select == 8)
      get_ctrl_stats()
   elsif (select == 9)
      puts "Goodbye\!"
      break
   else
      puts "please enter a valid number"
   end
end
