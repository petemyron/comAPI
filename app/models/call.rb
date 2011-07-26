class Call < ActiveRecord::Base
  validates :method_name, :presence => true, :uniqueness => true
  validates :endpoint_uri, :presence => true, :length => { :maximum => 255 }
#  validates :group_id, :presence => true unless :new_group_name?
  validates :group_id, :presence => true, :unless => lambda {|call| call.new_group_name.present? }
  
  belongs_to :group
  
  attr_accessor :new_group_name, :recent_group_id
  before_save :create_group_from_name
  
  def create_group_from_name
    create_group(:name => new_group_name) unless new_group_name.blank?
  end
  
  def self.search(search, tab)
    # options:
    #   | search | tab | tab == all | action         |
    # 1 | yes    | yes | yes        | search and all |
    # 2 | yes    | yes | no         | search and tab |
    # 3 | yes    | no  | no         | search and all |
    # 4 | no     | yes | yes        | all            |
    # 5 | no     | yes | no         | tab            |
    # 6 | no     | no  | no         | all            |
    # 7 | yes    | no  | yes        | not possible   |
    # 8 | no     | no  | yes        | not possible   |
    
    if (search.present? && tab.present? && tab == 'all')
      # should return search results in the 'all' tab
      # puts "MODEL 1: ==== search.present, tab.present, tab == all".blue
      where('method_name LIKE ?', "%#{search}%")
      
    elsif (search.present? && tab.present? && tab != "all")
      # should return search results in the respective tab
      # puts "MODEL 2: ==== search.present, tab.present, but!= all".blue
      where('method_name LIKE ? and group_id = ?', "%#{search}%", "#{Group.find_by_name(tab).id}")
    
    elsif (search.present? && tab.blank?)
      # should return search results in the 'all' tab
      # puts "MODEL 3: ==== search.present, tab.blank".blue
      where('method_name LIKE ?', "%#{search}%")
    
    elsif ((search.blank? || search == "" ) && tab.present? && tab == "all")
      # should return all calls in the 'all' tab
      # puts "MODEL 4: ==== search.blank, tab.present, tab == 'all'".blue
      scoped
    
    elsif ((search.blank? || search == "" ) && tab.present? && tab != "all")
      # puts "MODEL 5: ==== search.blank, tab.present, tab != 'all'".blue
      group_id = Group.find_by_name(tab).id
      where('group_id = ?', "#{group_id}")
    
    elsif ((search.blank? || search == "" ) && tab.blank?)
      # should return all calls in the 'all' tab
      # puts "MODEL 6: ==== search.blank, tab.blank".blue
      scoped
      
    else
      # puts "MODEL 7: ==== else".blue
      scoped
    
    end


  end  

end


