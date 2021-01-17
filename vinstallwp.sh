#!/bin/bash
#WP-CLI Documentation: https://developer.wordpress.org/cli/commands/
account=`whoami`
#subdomains support
dotscount=$(echo ${1}|grep -o "\."|wc -l)
if [ "$dotscount" -eq 0 ]
then
	host=${1}.example.com
else
	host=${1}
fi
web=/home/${account}/web/${host}/public_html
if [ -e ~/v-craatedomain.php ];
then
php ~/v-craatedomain.php $account $host
rm ~/v-craatedomain.php
else
echo "File ~/v-craatedomain.php does not exist - exiting."
fi
if [ ! -d ${web}/ ];
then
	echo 'Domain public_html folder does not exist, wrong value of $1 variable - exiting..'
	exit 1
fi
if [ -e ${web}/index.html ];
then
	rm ${web}/index.html
fi

if [ -e ${web}/robots.txt ];
then
	rm ${web}/robots.txt
fi
dblogin=$(tr -d -c 'A-Za-z0-9' </dev/urandom | head -c 6)
dbpass=$(tr -d -c 'A-Za-z0-9' </dev/urandom | head -c 20)
dbuser=$(tr -d -c 'A-Za-z0-9' </dev/urandom | head -c 6)
adminpass=$(tr -d -c 'A-Za-z0-9' </dev/urandom | head -c 20)
if [ -e ~/v-createdatabase.php ];
then
	php ~/v-createdatabase.php $account $dblogin $dbuser $dbpass
	rm ~/v-createdatabase.php
	echo "ALTER DATABASE ${account}_${dblogin} DEFAULT CHARACTER SET = 'utf8' DEFAULT COLLATE 'utf8_general_ci'" | mysql -u ${account}_${dbuser} -p${dbpass} ${account}_${dblogin}
fi
echo "User-agent: *
Disallow: /
" >> ${web}/robots.txt

dbprefix=$(tr -d -c 'A-Za-z0-9' </dev/urandom | head -c 14)

cd ${web}/ && wp core download
echo 'apache_modules:
  - mod_rewrite' > ${web}/wp-cli.yml
cd ${web}/ && wp core config --dbname=${account}_${dblogin} --dbuser=${account}_${dbuser} --dbpass=${dbpass} --dbprefix=${dbprefix}_
cd ${web}/ && wp core install --url="http://${host}/" --title=${host} --admin_user='admin' --admin_password="${adminpass}" --admin_email='test@example.com'
#Chenge LANGCODE below to correct language code
cd ${web}/ && wp core language install LANGCODE --activate
if [ -e ${web}/readme.html ];
then
	rm ${web}/readme.html
fi
#Install plugins, theme and configure WordPress
cd ${web}/ && wp comment delete $(wp comment list format=ids)
cd ${web}/ && wp plugin uninstall hello
cd ${web}/ && wp post delete $(wp post list --format=ids) --force
cd ${web}/ && wp post delete $(wp post list --post_type='page' --format=ids) --force
#Use slugs from wordpress.org https://wordpress.org/plugins/<slug>/
cd ${web}/ && wp plugin install plugin1,plugin2 --activate
cd ${web}/ && wp plugin update --all
cd ${web}/ && wp option update blog_public 0
cd ${web}/ && wp option update blogdescription ''
cd ${web}/ && wp core language update
#Astra below is only a example
cd ${web}/ && wp theme install astra --activate
cd ${web}/ && wp theme delete $(wp theme list --status=inactive --field=name)
cd ${web}/ && wp rewrite structure '/%postname%/' --hard
#Configure timezone - see https://www.php.net/manual/en/timezones.php
cd ${web}/ && wp option update 'timezone_string' 'Australia/North'
#Display access datails
echo "Database name: ${account}_${dblogin}
Host: localhost
Database user: ${account}_${dbuser}
Database user password: ${dbpass}

WordPress admin password: ${adminpass}"