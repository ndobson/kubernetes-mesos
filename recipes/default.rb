#
# Cookbook Name:: kubernetes-mesos
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

package 'rsync'
package 'go'

include_recipe 'kubernetes-mesos::docker_service' if node['kubernetes-mesos']['docker_service'].to_s
include_recipe 'kubernetes-mesos::etcd'

# Download and install kubernetes-mesos
k8sm_version = node['kubernetes-mesos']['version']
k8sm_stage_dir = node['kubernetes-mesos']['stage_dir']
k8sm_base_dir = "#{k8sm_stage_dir}/#{k8sm_version}/kubernetes-#{k8sm_version}"
k8sm_install_dir = node['kubernetes-mesos']['install_dir']
github_archive 'kubernetes' do
  version "v#{k8sm_version}"
  repo 'GoogleCloudPlatform/kubernetes'
  extract_to "#{k8sm_stage_dir}/#{k8sm_version}"
  # force true
end

execute 'build k8sm' do
  cwd k8sm_base_dir
  environment 'KUBERNETES_CONTRIB' => 'mesos'
  command 'make'
  not_if { ::Dir.exist?("#{k8sm_base_dir}/_output") }
end

link k8sm_install_dir do
  to "#{k8sm_base_dir}/_output/local/go"
end

directory node['kubernetes-mesos']['config_dir']
directory node['kubernetes-mesos']['log_dir']

template node['kubernetes-mesos']['config_file'] do
  source 'mesos-cloud.erb'
  mode '0644'
end

node['kubernetes-mesos']['services'].each do |svc, args|
  template "km-#{svc}" do
    path "/etc/init.d/km-#{svc}"
    source 'km-init.erb'
    mode '0755'
    variables(
      'service' => svc,
      'args' => args,
      'config' => node['kubernetes-mesos']['config_file']
    )
  end
  service "km-#{svc}" do
    supports 'status' => true
    action [:enable, :start]
    subscribes :restart, "template[#{node['kubernetes-mesos']['config_file']}]"
    subscribes :restart, "template[km-#{svc}]"
  end
end

# Create Kubectl config for root
execute 'kubectl config cluster' do
  command <<-EOH
    kubectl config set-cluster local --server=http://#{node['ipaddress']}:8888 && \
    kubectl config set-context local --cluster=local && \
    kubectl config use-context local
  EOH
  environment 'PATH' => "#{node['kubernetes-mesos']['bin_dir']}:#{ENV['PATH']}"
end

# Install Kube UI
# execute 'Install Kube UI' do
#   command <<-EOH
# kubectl create -f kube-ui-rc.yaml --namespace=kube-system && \
# kubectl create -f kube-ui-svc.yaml --namespace=kube-system
#   EOH
#   environment 'PATH' => "#{node['kubernetes-mesos']['bin_dir']}:#{ENV['PATH']}"
#   cwd "#{k8sm_base_dir}/cluster/addons/kube-ui"
#   only_if node['kubernetes-mesos']['kube_ui'].to_s
#   not_if 'kubectl get svc,rc --namespace=kube-system | grep kube-ui', 'environment' => {
#     'PATH' => "#{node['kubernetes-mesos']['bin_dir']}:#{ENV['PATH']}"
#   }
# end
