k8sm = default['kubernetes-mesos']

k8sm['etcd']['image_name'] = 'quay.io/coreos/etcd'
k8sm['etcd']['image_tag'] = 'v2.0.12'

k8sm['version'] = '1.0.1'
k8sm['docker_service'] = false
k8sm['kube_ui'] = true

k8sm['stage_dir'] = '/opt/k8s_stage'
k8sm['install_dir'] = '/opt/kubernetes'
k8sm['bin_dir'] = "#{node['kubernetes-mesos']['install_dir']}/bin"
k8sm['config_dir'] = '/etc/kubernetes-mesos'
k8sm['config_file'] = "#{node['kubernetes-mesos']['config_dir']}/mesos-cloud.conf"
k8sm['log_dir'] = '/var/log/kubernetes-mesos'

k8sm['services'] = {
  'apiserver' => "--address=#{node['ipaddress']} \
                  --etcd-servers=http://#{node['ipaddress']}:4001 \
                  --service-cluster-ip-range=10.10.10.0/24 \
                  --port=8888 \
                  --cloud-provider=mesos \
                  --cloud-config=$config \
                  --v=1",
  'controller-manager' => "--master=#{node['ipaddress']}:8888 \
                           --cloud-provider=mesos \
                           --cloud-config=#{node['kubernetes-mesos']['config_file']}  \
                           --v=1",
  'scheduler' => "--address=#{node['ipaddress']} \
                  --mesos-master=#{node['ipaddress']}:5050 \
                  --etcd-servers=http://#{node['ipaddress']}:4001 \
                  --mesos-user=root \
                  --api-servers=#{node['ipaddress']}:8888 \
                  --cluster-dns=10.10.10.10 \
                  --cluster-domain=cluster.local \
                  --v=2"
}
