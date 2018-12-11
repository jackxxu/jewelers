require 'active_record'
require 'pry'

namespace :db do
  db_config       = YAML::load(File.open('config/database.yml'))
  db_config_admin = db_config.merge({'database' => 'postgres', 'schema_search_path' => 'public'})

  desc 'Create the database'
  task :create do
    ActiveRecord::Base.establish_connection(db_config_admin)
    ActiveRecord::Base.connection.create_database(db_config['database'])
    puts 'Database created.'
  end

  desc 'Migrate the database'
  task :migrate do
    ActiveRecord::Base.establish_connection(db_config)
    ActiveRecord::MigrationContext.new('db/migrate/').migrate
    puts 'Database migrated.'
  end

end