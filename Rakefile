require 'rubygems'
require 'rake/gempackagetask'
require 'rake/testtask'
require 'lib/rmilk/version'

spec = Gem::Specification.new do |s|
  s.name = 'rmilk'
  s.version = ConsoleRtm::Version.to_s
  s.has_rdoc = true
  s.extra_rdoc_files = %w(README.rdoc)
  s.rdoc_options = %w(--main README.rdoc)
  s.summary = "This gem provides a console ui for RMilk service "
  s.author = 'Victor Savkin'
  s.email = 'avix1000@gmail.com'
  s.homepage = 'http://vsavkin.wordpress.com/'
  s.files = %w(README.rdoc Rakefile) + Dir.glob("{bin,lib,test}/**/*")
  s.bindir = "bin"
  s.executables    = ['rmilk']

  s.add_dependency('flexmock')
  s.add_dependency('rufus-rtm')
  s.add_dependency('require_all')
  s.add_dependency('json_pure')
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
end

begin
  require 'rcov/rcovtask'

  Rcov::RcovTask.new(:coverage) do |t|
    t.libs = ['test']
    t.test_files = FileList["test/**/*_test.rb"]
    t.verbose = true
    t.rcov_opts = ['--text-report', "-x #{Gem.path}", '-x /Library/Ruby', '-x /usr/lib/ruby']
  end

  task :default => :coverage

rescue LoadError
  warn "\n**** Install rcov (sudo gem install relevance-rcov) to get coverage stats ****\n"
  task :default => :test
end


desc 'Generate the gemspec to serve this Gem from Github'
task :github do
  file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
  File.open(file, 'w') {|f| f << spec.to_ruby }
  puts "Created gemspec: #{file}"
end