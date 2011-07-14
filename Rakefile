# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

# to resolve this warning from showing up when using rake: 
#    WARNING: Global access to Rake DSL methods is deprecated.  Please include
#    ...  Rake::DSL into classes and modules which use the Rake DSL methods.
include Rake::DSL

ComAPI::Application.load_tasks

