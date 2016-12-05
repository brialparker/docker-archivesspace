#!/bin/bash

cat /dev/null > /config/config.rb

echo "AppConfig[:search_user_secret] = \""$(ruby  -e "require 'securerandom'; print SecureRandom.hex;")"\"" >> /config/config.rb
echo "AppConfig[:public_user_secret] = \""$(ruby  -e "require 'securerandom'; print SecureRandom.hex;")"\""  >> /config/config.rb
echo "AppConfig[:staff_user_secret] = \""$(ruby  -e "require 'securerandom'; print SecureRandom.hex;") "\""  >> /config/config.rb
echo "AppConfig[:frontend_cookie_secret] = \""$(ruby  -e "require 'securerandom'; print SecureRandom.hex;")"\""  >> /config/config.rb
echo "AppConfig[:public_cookie_secret] = \""$(ruby  -e "require 'securerandom'; print SecureRandom.hex;")"\"" >> /config/config.rb


if [[ "$ARCHIVESSPACE_DB_TYPE" == "mysql" ]]; then
  echo "AppConfig[:db_url] = 'jdbc:mysql://$DB_PORT_3306_TCP_ADDR:3306/$ARCHIVESSPACE_DB_NAME?user=$ARCHIVESSPACE_DB_USER&password=$ARCHIVESSPACE_DB_PASS&useUnicode=true&characterEncoding=UTF-8'" \
    >> /config/config.rb
  /scripts/setup-database.sh
fi


if [[ $FRONTEND_PROXY_URL ]]; then
  echo "AppConfig[:frontend_proxy_url] = \"$FRONTEND_PROXY_URL\"" >> /config/config.rb 
fi

if [[ $FRONTEND_PREFIX ]]; then
  echo "AppConfig[:frontend_prefix] = \"$FRONTEND_PREFIX\"" >> /config/config.rb 
fi

if [[ $PUBLIC_PROXY_URL ]]; then
  echo "AppConfig[:public_proxy_url] = \"$PUBLIC_PROXY_URL\"" >> /config/config.rb 
fi

if [[ $PUBLIC_PREFIX ]]; then
  echo "AppConfig[:public_prefix] = \"$PUBLIC_PREFIX\"" >> /config/config.rb 
fi

for PLUGIN in /archivesspace/plugins/*; do
  [[ -d $PLUGIN ]] && echo "AppConfig[:plugins] << '${PLUGIN##*/}'" >> /config/config.rb
done

exec /archivesspace.sh
