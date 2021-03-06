

package 'java-1.7.0-openjdk-devel'
group 'chef' do
  action :create
end
user 'chef' do
  group 'chef'
end

 remote_file '/tmp/apache-tomcat-8.5.11.tar.gz' do
 source 'http://apache.mirrors.tds.net/tomcat/tomcat-8/v8.5.11/bin/apache-tomcat-8.5.11.tar.gz'

 end

directory '/opt/tomcat' do
  action :create
  recursive true
end
execute 'extract_tomcat' do
  command 'tar xvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1'
  cwd '/tmp'
end
execute 'chgrp -R chef /opt/tomcat/conf'
directory '/opt/tomcat/conf' do
  group 'chef'
  mode '0474'
end
execute 'chmod g+r conf/*' do
  cwd '/opt/tomcat'
end
execute 'chown -R chef webapps/ work/ temp/ logs/ conf/' do
  cwd '/opt/tomcat'
end

template '/etc/systemd/system/tomcat.service' do
  source 'tomcat.service.erb'
end

execute 'systemctl daemon-reload'
#execute 'systemctl enable tomcat'
#execute 'systemctl start tomcat'

service 'tomcat' do
  action [:start, :enable]
end

