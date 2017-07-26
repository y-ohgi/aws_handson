# timezoneの設定
execute 'set timezone' do
  user "root"
  command <<-EOL
        cp -p /usr/share/zoneinfo/Japan /etc/localtime
        echo 'ZONE="Asia/Tokyo"' > /etc/sysconfig/clock
        echo 'UTC=false' >> /etc/sysconfig/clock
    EOL
end

# yumのアップデート
execute 'yum update' do
  user "root"
  command "yum update -y"
end

# epelリポジトリの追加
package "epel-release"

# emacsのインストール
package "emacs"
# emacsのコンフィグを適用
remote_file "/usr/share/emacs/site-lisp/site-start.d/init.el" do
  owner "root"
  group "root"
  mode  "777"
  source "files/.emacs.d/init.el"
end

### nginx
# nginxのインストール
package 'nginx'

# コンフィグ格納用ディレクトリの作成
directory "/etc/nginx/conf.d" do
  owner "root"
  group "root"
  mode  "755"
end

# nginx.confの設置
template "/etc/nginx/nginx.conf" do
  source "templates/etc/nginx/nginx.conf"
  mode "644"
  owner "root"
  group "root"
end

### php
# phpのインストール
package 'php70'
package 'php70-fpm'
package 'php70-mysqlnd'
package 'php70-mbstring'
package 'php70-mcrypt'
package 'php70-pdo'
package 'php70-xml'

template "/etc/php-fpm-7.0.d/www.conf" do
  source "templates/etc/php-fpm-7.0.d/www.conf"
  mode "644"
  owner "root"
  group "root"
end

service 'php-fpm' do
  action [:enable, :start]
end

### laravel
# composerのインストール
# yumのアップデート
execute 'install composer' do
  user "root"
  command <<-EOL
curl -sS https://getcomposer.org/installer | sudo php
cp composer.phar /usr/local/bin/composer
ln -s /usr/local/bin/composer /usr/bin/composer
EOL
end

# laravelの配置
execute 'create laravel project' do
  user "root"
  command <<-EOL
cd /usr/share/nginx
composer create-project --prefer-dist laravel/laravel
mv laravel app
chown -R root:nginx /usr/share/nginx
chmod -R 777 app/storage
EOL
end


