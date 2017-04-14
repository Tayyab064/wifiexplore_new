class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private
  def restrict_lender
    restrict_access_to_lender || render_unauthorized
  end

  def restrict_access_to_lender
    authenticate_or_request_with_http_token do |token, _options|
      if Lender.exists?(token: token) && (user = Lender.find_by_token(token))
        @current_lender = user
      end
    end
  end

  def is_lender
    if session[:lender].present?
      unless u = Lender.find_by_email(session[:lender])
          if u.blocked == false
          redirect_to lender_signin_page_path
          end
      end
      @lender = u
    else
      redirect_to lender_signin_page_path
    end
  end

  def is_admin
    if session[:admin].present?
      unless u = Admin.find_by_email(session[:admin])
        redirect_to admin_signin_page_path
      end
      @admin = u
    else
      redirect_to admin_signin_page_path
    end
  end

end
