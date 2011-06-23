class Call < ActiveRecord::Base
  validates :method_name, :presence => true
  validates :endpoint_uri, :presence => true
  validates :xml, :presence => true

  def self.search(search)
    if search
      where('method_name LIKE ?', "%#{search}%")
    else
      scoped
    end
  end
end

