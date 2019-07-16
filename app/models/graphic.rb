class Graphic < ApplicationRecord
  # acts_as_paranoid

  belongs_to :user

  # include Authority::Abilities
  # self.authorizer_name = 'GaphicAuthorizer'

  def self.color
    'teal'
  end

  def self.hex_color
    '#009688'
  end

  def self.icon
    'graphic'
  end

  def name
    title
  end

  def universe_field_value
    #todo when graphics belong to a universe
  end
end
