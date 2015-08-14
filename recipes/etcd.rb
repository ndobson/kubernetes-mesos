docker_image node['kubernetes-mesos']['etcd']['image_name'] do
  tag node['kubernetes-mesos']['etcd']['image_tag']
end

# Launch etcd
docker_container 'etcd' do
  detach true
  hostname node['hostname']
  image node['kubernetes-mesos']['etcd']['image_name']
  tag node['kubernetes-mesos']['etcd']['image_tag']
  port ['4001:4001', '7001:7001']
  command "--listen-client-urls http://0.0.0.0:4001 --advertise-client-urls http://#{node['ipaddress']}:4001"
end
