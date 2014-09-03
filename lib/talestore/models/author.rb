module Talestore
  class Author < ActiveRecord::Base
    has_and_belongs_to_many :tales

    # Validations
    validates_presence_of :name
    validates_length_of :name, :maximum=>250
    validates_presence_of :surname
    validates_length_of :surname, :maximum=>250

    # Delegations

    # Callbacks

    # Scopes


  end   
end
