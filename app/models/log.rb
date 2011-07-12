class Log < ActiveRecord::Base
  validates :method_name, :presence => true
  validates :user_id, :presence => true
  
  belongs_to :user
  
  def self.search(search, page, current_user_id, see_all)
    if current_user_id.nil?
      # User isn't signed in, look up all history
      paginate :per_page => 20, :page => page,
             :conditions => ['method_name like ?', "%#{search}%"],
             :order => 'created_at DESC'
    else
      # User *is* signed in, check if they want to see all history or just theirs
      if see_all.present?
        # look up all history
        paginate :per_page => 20, :page => page,
                 :conditions => ['method_name like ?', "%#{search}%"],
                 :order => 'created_at DESC'
      else
        # look up only their history
        paginate :per_page => 20, :page => page,
                 :conditions => ['method_name like ? and user_id = ?', "%#{search}%", "#{current_user_id}"],
                 :order => 'created_at DESC'
      end
    end
  end
  
end
