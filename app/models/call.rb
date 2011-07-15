class Call < ActiveRecord::Base
  validates :method_name, :presence => true, :uniqueness => true
  validates :endpoint_uri, :presence => true, :length => { :maximum => 255 }
  validates :group_id, :presence => true unless :new_group_name?
  
  belongs_to :group
  
  attr_accessor :new_group_name
  before_save :create_group_from_name
  
  def create_group_from_name
    puts "in create_group_from_name"
    create_group(:name => new_group_name) unless new_group_name.blank?
  end
  
  def self.search(search, tab)
    
    if (search.present? && tab.present? && tab != "All")
      # look up the right ID once, instead of for each row in the Calls table
#      puts "\n==== search is present, tab is present, tab isn't All\n"
      @group_id = Group.find_by_name(tab).id
      where('method_name LIKE ? and group_id = ?', "%#{search}%", "#{@group_id}")
    elsif (search.present? && tab != "All")
#      puts "==== search is present, tab isn't All"
      where('method_name LIKE ?', "%#{search}%")
    elsif (!search.present? && tab.present? && tab != "All")
      # look up the right ID once, instead of for each row in the Calls table
#      puts "==== search not present, tab is present and not All"
      @group_id = Group.find_by_name(tab).id
      where('group_id = ?', "#{@group_id}")
    else # !search && !tab 
#      puts "==== search not present, tab is All"
      scoped
    end
#    if user_signed_in?
#        current_user.recent_group_id = @group_id
#    end
  end  

end

