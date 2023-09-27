class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  # 例外処理の追加
  rescue_from Exception, with: :render_500 unless Rails.env.development?
  rescue_from ActiveRecord::RecordNotFound, with: :render_404 unless Rails.env.development?
  rescue_from ActionController::RoutingError, with: :render_404 unless Rails.env.development?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  private

  def render_404
    render template: "errors/404", status: 404
  end

  def render_500(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")
    render template: "errors/500", status: 500
  end
end
