class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  has_many :logs
  
  def update_recent_group_id(id)
#    puts "USER MOD: before #{self.recent_group_id}"
    self.recent_group_id = id
    self.save!
#    puts "USER MOD: after #{self.recent_group_id}"
  end
end
