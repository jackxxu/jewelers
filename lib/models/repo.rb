class Repo < ActiveRecord::Base
  has_many :uses
  has_many :libraries, through: :uses

  # def unsanctioned
  #   libraries_names.select {|_, v| v}
  #                  .map {|k, _| k}
  # end

end