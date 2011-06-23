class CommonParam < ActiveRecord::Base

  def self.search(cp_search)
    if cp_search
      where('name LIKE ?', "%#{cp_search}%")
    else
      scoped
    end
  end
end

