# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

# Load tasks defined on lib/tasks folder
Dir[File.join(File.dirname(__FILE__), "lib", "tasks", "**", "*.rake")].each { |f| import f }

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://guides.rubygems.org/specification-reference/ for more options
  gem.name = "talestore"
  gem.homepage = "http://github.com/rmoliva/talestore"
  gem.license = "MIT"
  gem.summary = "Summary pending"
  gem.description = "Description pending"
  gem.email = "floyd303@gmail.com"
  gem.authors = ["Roberto M. Oliva"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

desc "Code coverage detail"
task :simplecov do
  ENV['COVERAGE'] = "true"
  Rake::Task['test'].execute
end

task :environment do
  DATABASE_ENV = ENV['DATABASE_ENV'] || 'development'
  MIGRATIONS_DIR = ENV['MIGRATIONS_DIR'] || 'db/migrate'
  require File.join(File.dirname(__FILE__), 'lib', 'talestore.rb')
  @config = YAML.load_file('config/databases.yml')[DATABASE_ENV]
  ActiveRecord::Base.establish_connection @config
  ActiveRecord::Base.logger = Logger.new(File.join(File.dirname(__FILE__), 'log', 'development.log'))
end

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "talestore #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc "Start IRB with all runtime dependencies loaded"
task :console, [:script] => :environment do |t,args|
  # TODO move to a command
  dirs = ['ext', 'lib'].select { |dir| File.directory?(dir) }

  original_load_path = $LOAD_PATH

  cmd = if File.exist?('Gemfile')
          require 'bundler'
          Bundler.setup(:default)
        end

  # add the project code directories
  $LOAD_PATH.unshift(*dirs)

  # clear ARGV so IRB is not confused
  ARGV.clear

  require 'irb'

  # set the optional script to run
  IRB.conf[:SCRIPT] = args.script
  IRB.start

  # return the $LOAD_PATH to it's original state
  $LOAD_PATH.reject! { |path| !(original_load_path.include?(path)) }
end
