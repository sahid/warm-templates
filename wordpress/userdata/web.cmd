#!/bin/bash

IP_SQL=10.123.2.2 # MySQL IP
IP_WEB=`/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`


### WordPress

cat << EOF > /etc/wordpress/wp-config.php
<?php
define('DB_NAME', 'wordpress_db');
define('DB_USER', 'wordpress_user');
define('DB_PASSWORD', 'cloudwatt');
define('DB_HOST', '$IP_SQL');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');

define('AUTH_KEY',         'QeCb4\!MZ3?B?\$uw&2T8|E*3PnfLg&_jC8.@}d^X7oSA1MV\!yt\`sYI[OKTc@.qa82');
define('SECURE_AUTH_KEY',  'jpZK*lB*B+%*^wgKn%*J|Aru8[ah9)b{=,j%3OBH]~B6q;t54rEJ.Ll5rmHr6_-w');
define('LOGGED_IN_KEY',    'DqQw{8MT).p9OcNym Udz9[MD[^=Sp5I$.v2{]U8pqzMd\!iq,FQWCljWLQKgcJS,');
define('NONCE_KEY',        'WT2b%Az^D)l4bO\`g44(^Z&\`mNf?7Hc5N>Z:[GRSj\!>lWB%a%~Ui/H?ypGu6Z#AXm');
define('AUTH_SALT',        'uq.ZBzXNqJbV,qfqLCkM+\`)\!)0<(m)_z4mV\!umh<jp_ (DsN:&,Ky*d3v<6@\$g;]');
define('SECURE_AUTH_SALT', '-}8hWD;{ z|gaPuGsuH@1%]ISqG#A&G:ci{VBc-uKS0yX[(T5BK>]l_A8~\!D~RL-');
define('LOGGED_IN_SALT',   'K\`2Yy:0hCQG1zD6jE;h,yGnS,hpz@p/bc[@8 WWC )a/S9,e;Tc)1/F[8N*&Nzd#');
define('NONCE_SALT',       '%#&u*vfC|kdO?W#;g.=bs@ _Rnuj:~ESRi.Fu:mp]1K3Gul#mtc 1-sezWh[{/Ro');

\$table_prefix  = 'wp_';

define ('WPLANG', '');
define('WP_DEBUG', false);

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
    define('ABSPATH', dirname(__FILE__) . '/');

    /** Sets up WordPress vars and included files. */
    require_once(ABSPATH . 'wp-settings.php');
EOF


### Apache

ln -s /usr/share/wordpress /var/www/$IP_WEB
chown -R www-data:www-data /var/www/$IP_WEB

cat << EOF > /etc/apache2/sites-available/wordpress
<VirtualHost *:8080>
ServerName wordpress
ServerAdmin server@admin
DocumentRoot /var/www/$IP_WEB/
<Directory />
Options FollowSymLinks
AllowOverride All
</Directory>
ErrorLog /var/log/apache2/error.log
CustomLog /var/log/apache2/access.log combined
LogLevel warn
</VirtualHost>
EOF

a2ensite wordpress
sed 's/80/8080/g' -i /etc/apache2/ports.conf
service apache2 reload 

