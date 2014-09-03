module Talestore
  class Tale < ActiveRecord::Base
    has_and_belongs_to_many :authors

    # Validations
    validates_presence_of :title
    validates_length_of :title, :maximum=>250

    # Delegations

    # Callbacks

    # Scopes


  end   
end
