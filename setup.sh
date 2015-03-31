#!/bin/bash

cat /dev/null > /archivesspace/config/config.rb


echo "
AppConfig[:search_user_secret] = \"#{SecureRandom.hex}\"\n
AppConfig[:public_user_secret] = \"#{SecureRandom.hex}\"\n
AppConfig[:staff_user_secret] = \"#{SecureRandom.hex}\"\n
AppConfig[:frontend_cookie_secret] = \"#{SecureRandom.hex}\"\n
AppConfig[:public_cookie_secret] = \"#{SecureRandom.hex}\"\n
" >> /archivesspace/config/config.rb


if [[ "$ARCHIVESSPACE_DB_TYPE" == "mysql" ]]; then
  echo "AppConfig[:db_url] = 'jdbc:mysql://$DB_PORT_3306_TCP_ADDR:3306/$ARCHIVESSPACE_DB_NAME?user=$ARCHIVESSPACE_DB_USER&password=$ARCHIVESSPACE_DB_PASS&useUnicode=true&characterEncoding=UTF-8'" \
    >> /archivesspace/config/config.rb
  /archivesspace/scripts/setup-database.sh
fi


if [[ $FRONTEND_PROXY_URL ]]; then
  echo "AppConfig[:frontend_proxy_url] = \"$FRONTEND_PROXY_URL\"" >> /archivesspace/config/config.rb 
fi

if [[ $FRONTEND_PREFIX ]]; then
  echo "AppConfig[:frontend_prefix] = \"$FRONTEND_PREFIX\"" >> /archivesspace/config/config.rb 
fi

if [[ $PUBLIC_PROXY_URL ]]; then
  echo "AppConfig[:public_proxy_url] = \"$PUBLIC_PROXY_URL\"" >> /archivesspace/config/config.rb 
fi

if [[ $PUBLIC_PREFIX ]]; then
  echo "AppConfig[:public_prefix] = \"$PUBLIC_PREFIX\"" >> /archivesspace/config/config.rb 
fi

for PLUGIN in /archivesspace/plugins/*; do
  [[ -d $PLUGIN ]] && echo "AppConfig[:plugins] << '${PLUGIN##*/}'" >> /archivesspace/config/config.rb
done

exec /archivesspace/archivesspace.sh
