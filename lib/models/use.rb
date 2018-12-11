class Use < ActiveRecord::Base
  belongs_to :repo
  belongs_to :library
end