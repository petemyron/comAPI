class Call < ActiveRecord::Base
  validates :method_name, :presence => true, :uniqueness => true
  validates :endpoint_uri, :presence => true
  belongs_to :group
  attr_accessor :new_group_name
  before_save :create_group_from_name
  
  def create_group_from_name
    create_group(:name => new_group_name) unless new_group_name.blank?
  end

  def self.search(search)
    if search
      where('method_name LIKE ?', "%#{search}%")
    else
      scoped
    end
  end
end

