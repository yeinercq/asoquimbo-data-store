class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :authenticate_user!
  before_action :set_locale

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_path, alert: "No está autorizado para realizar esta acción." }
      format.turbo_stream do
        flash.now[:alert] = "No está autorizado para realizar esta acción."
        render turbo_stream: turbo_stream.prepend("flash_notifications", partial: "layouts/flash_notifications")
      end
    end
  end

  def set_locale
    I18n.locale = "es"
  end
end
