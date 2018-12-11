class Repo < ActiveRecord::Base
  has_many :uses
  has_many :libraries, through: :uses

  # def unsanctioned
  #   libraries_names.select {|_, v| v}
  #                  .map {|k, _| k}
  # end

  def gemfile_url
    file_url('Gemfile')
  end

  def gemfilelock_url
    file_url('Gemfile.lock')
  end

  private

  def file_url(file)
    "#{gitlab_url}/raw/master/#{file}"
  end
end