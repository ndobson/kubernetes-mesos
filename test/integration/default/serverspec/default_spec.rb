require 'spec_helper'

describe 'kubernetes-mesos::default' do
  # Serverspec examples can be found at
  # http://serverspec.org/resource_types.html
  it 'starts services' do
    %w( km-apiserver km-controller-manager km-scheduler ).each do |svc|
      service(svc) do
        it { should be_enabled }
      end
    end
  end
end
