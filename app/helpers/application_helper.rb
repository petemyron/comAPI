module ApplicationHelper
  def admin?
    params[:admin].to_s == "true"
  end
end
