#!/bin/bash

cat /dev/null > /archivesspace/config/archivesspace/config-defaults.rb

echo "AppConfig[:search_user_secret] = \""$(ruby  -e "require 'securerandom'; print SecureRandom.hex;")"\"" >> /archivesspace/config/archivesspace/config-defaults.rb
echo "AppConfig[:public_user_secret] = \""$(ruby  -e "require 'securerandom'; print SecureRandom.hex;")"\""  >> /archivesspace/config/archivesspace/config-defaults.rb
echo "AppConfig[:staff_user_secret] = \""$(ruby  -e "require 'securerandom'; print SecureRandom.hex;") "\""  >> /archivesspace/config/archivesspace/config-defaults.rb
echo "AppConfig[:frontend_cookie_secret] = \""$(ruby  -e "require 'securerandom'; print SecureRandom.hex;")"\""  >> /archivesspace/config/archivesspace/config-defaults.rb
echo "AppConfig[:public_cookie_secret] = \""$(ruby  -e "require 'securerandom'; print SecureRandom.hex;")"\"" >> /archivesspace/config/archivesspace/config-defaults.rb


if [[ "$ARCHIVESSPACE_DB_TYPE" == "mysql" ]]; then
  echo "AppConfig[:db_url] = 'jdbc:mysql://$DB_PORT_3306_TCP_ADDR:3306/$ARCHIVESSPACE_DB_NAME?user=$ARCHIVESSPACE_DB_USER&password=$ARCHIVESSPACE_DB_PASS&useUnicode=true&characterEncoding=UTF-8'" \
    >> /archivesspace/config/archivesspace/config-defaults.rb
  /scripts/setup-database.sh
fi


if [[ $FRONTEND_PROXY_URL ]]; then
  echo "AppConfig[:frontend_proxy_url] = \"$FRONTEND_PROXY_URL\"" >> /archivesspace/config/archivesspace/config-defaults.rb 
fi

if [[ $FRONTEND_PREFIX ]]; then
  echo "AppConfig[:frontend_prefix] = \"$FRONTEND_PREFIX\"" >> /archivesspace/config/archivesspace/config-defaults.rb 
fi

if [[ $PUBLIC_PROXY_URL ]]; then
  echo "AppConfig[:public_proxy_url] = \"$PUBLIC_PROXY_URL\"" >> /archivesspace/config/archivesspace/config-defaults.rb 
fi

if [[ $PUBLIC_PREFIX ]]; then
  echo "AppConfig[:public_prefix] = \"$PUBLIC_PREFIX\"" >> /archivesspace/config/archivesspace/config-defaults.rb 
fi

for PLUGIN in /archivesspace/plugins/*; do
  [[ -d $PLUGIN ]] && echo "AppConfig[:plugins] << '${PLUGIN##*/}'" >> /archivesspace/config/archivesspace/config-defaults.rb
done

exec /archivesspace/archivesspace.sh
