class Pic < ActiveRecord::Base
  
  validates_presence_of :img_src, :setname
  validates_length_of :img_src, :in => 12..2500
  validates_length_of :setname, :maximum => 25
  validates_length_of :caption, :maximum => 100
  validate :valid_height
  
  def valid_height
    if img_height.nil? || img_height.blank? || img_height < 1
      errors.add(:img_height, "couldn't get image height, image URL may be invalid")
    end
  end
                                          
end
