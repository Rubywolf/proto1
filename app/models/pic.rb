class Pic < ActiveRecord::Base
  
  validates_presence_of :img_src, :setname
  validates_length_of :img_src, :in => 12..2500
  validates_length_of :setname, :maximum => 25
  validates_length_of :caption, :maximum => 100
                                          
end
