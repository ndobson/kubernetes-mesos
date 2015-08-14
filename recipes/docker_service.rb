package 'libcgroup'

docker_service 'default' do
  http_proxy Chef::Config.http_proxy if Chef::Config.http_proxy
  https_proxy Chef::Config.https_proxy if Chef::Config.https_proxy
  no_proxy Chef::Config.no_proxy if Chef::Config.no_proxy
  action [:create, :start]
end
