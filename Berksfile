source 'https://supermarket.chef.io'

metadata

cookbook 'github', git: 'https://github.com/ndobson/github-cookbook.git'

group :integration do
  cookbook 'yum-epel'
  cookbook 'mesos'
end
