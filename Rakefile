require 'bundler/setup'
require 'rubocop/rake_task'
require 'foodcritic'
require 'kitchen'

# Style tests. Rubocop and Foodcritic
namespace :style do
  desc 'Run Ruby style checks'
  RuboCop::RakeTask.new(:ruby)

  desc 'Run Chef style checks'
  FoodCritic::Rake::LintTask.new(:chef) do |t|
    t.options = {
      fail_tags: ['any']
    }
  end
end

desc 'Run all style checks'
task style: ['style:chef', 'style:ruby']

# Integration tests. Kitchen.ci
namespace :integration do
  desc 'Run Test Kitchen with Vagrant'
  task :vagrant do
    Kitchen.logger = Kitchen.default_file_logger
    Kitchen::Config.new.instances.each do |instance|
      instance.test(:always)
    end
  end
end

# Unit tests with rspec/chefspec
namespace :unit do
  begin
    require 'rspec/core/rake_task'
    desc 'Run unit tests with RSpec/ChefSpec'
    RSpec::Core::RakeTask.new(:rspec) do |t|
      t.rspec_opts = [].tap do |a|
        a.push('--color')
        a.push('--format progress')
      end.join(' ')
    end
  rescue LoadError
    puts '>>>>> rspec gem not loaded, omitting tasks' unless ENV['CI']
  end
end

task unit: ['unit:rspec']

desc 'Run all tests on Travis'
task travis: %w(style unit)

task default: %w( style unit integration:vagrant )
