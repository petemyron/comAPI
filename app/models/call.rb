class Call < ActiveRecord::Base
  validates :method_name, :presence => true
  validates :endpoint_uri, :presence => true
  validates :xml, :presence => true
end

