require './models/sanctioned_library'

class CreateSanctionedLibrariesList < ActiveRecord::Migration[5.2]
  def change
    %w{savon specific_install fiddle terminal-table cucumber-rails unidecoder
       benchmark-ips database_cleaner dotenv-rails figaro guard-rspec hashdiff
       ibsciss-middleware postgresql_cursor prometheus-client pry-byebug
       rails-perftest rubocop ruby-prof scenic silencer stackprof terminal-notifier-guard
       vcr webmock csv_decision sqlite3 timecop action_message app_logger bulk_insert
       classy_hash client_schema rest-helper schema_table curb entitlement-helper
       rack-cors interactive_editor spoon interactor-rails activeresource flatten_hash
       light-service rufus-scheduler parallel time_difference redis hiredis record-classifier
       hflr elif resque ox classy_hash schema_validation decision_table webpacker bootsnap
       uglifier net-ldap jwt tzinfo-data xmlhasher hashtran moserr message_mock file_helper
       hash_check pts_schema rubocop-rspec mostyler
      }.each do |name|
      SanctionedLibrary.create(name: name)
    end
  end
end