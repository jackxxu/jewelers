class Repo < ActiveRecord::Base
  has_many :uses
  has_many :libraries, through: :uses
end