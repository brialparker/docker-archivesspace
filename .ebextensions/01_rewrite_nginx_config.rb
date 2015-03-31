#! /usr/bin/ruby
#
#

conf = "/etc/nginx/conf.d/elasticbeanstalk-nginx-docker-upstream.conf"
if File.exists?(conf)
  nginx_conf_file = IO.read(conf).gsub("docker", "public").gsub(":8080", ":8081" )

  nginx_site_file = <<-eos

  server {
    listen 80;
    server_name public.archivesspace.org; 
    location / {
      proxy_pass http://public/;
      proxy_http_version  1.1;
      proxy_set_header    Connection          $connection_upgrade;
      proxy_set_header    Upgrade             $http_upgrade;
      proxy_set_header    Host                $host;
      proxy_set_header    X-Real-IP           $remote_addr;
      proxy_set_header    X-Forwarded-For     $proxy_add_x_forwarded_for;
    }
   }     
eos

  File.open("/etc/nginx/conf.d/public-upstream.conf", 'w') { |f| f << nginx_conf_file }
  File.open("/etc/nginx/sites-enabled/public.conf", 'w') { |f| f << nginx_site_file }

  `service nginx restart`
end
