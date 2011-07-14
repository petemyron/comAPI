class Call < ActiveRecord::Base
  validates :method_name, :presence => true, :uniqueness => true
  validates :endpoint_uri, :presence => true, :length => { :maximum => 255 }
  validates :group_id, :presence => true unless :new_group_name?
  
  belongs_to :group
  
  attr_accessor :new_group_name
  before_save :create_group_from_name
  
  def create_group_from_name
    create_group(:name => new_group_name) unless new_group_name.blank?
  end
  
  def self.search(search, tab)
    
    if (search.present? && tab.present?)
      # look up the right ID once, instead of for each row in the Calls table
      @group_id = Group.find_by_name(tab).id
      where('method_name LIKE ? and group_id = ?', "%#{search}%", "#{@group_id}")
    elsif (search.present? && !tab.present?)
      where('method_name LIKE ?', "%#{search}%")
    elsif (!search.present? && tab.present?)
      # look up the right ID once, instead of for each row in the Calls table
      @group_id = Group.find_by_name(tab).id
       where('group_id = ?', "#{@group_id}")
    else # !search && !tab 
      scoped
    end
  end
  
end

