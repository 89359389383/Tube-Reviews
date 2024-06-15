# app/controllers/application_controller.rb

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  # 例外処理の追加
  rescue_from Exception, with: :render_500 unless Rails.env.development?
  rescue_from ActiveRecord::RecordNotFound, with: :render_404 unless Rails.env.development?
  rescue_from ActionController::RoutingError, with: :render_404 unless Rails.env.development?

  def new_guest
    user = User.find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = 'ゲスト' # ここで適切な名前を設定
      # その他必要なユーザー情報の設定
    end
    sign_out_all_scopes # ログアウトしてセッションをリセット
    sign_in(user)
    reset_guest_session # セッション情報のリセットメソッドを呼び出し
    clear_guest_reviews(user) # ゲストユーザーの感想データを削除
    redirect_to search_videos_path, notice: 'ゲストユーザーとしてログインしました。'
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def set_resource(resource_name)
    instance_variable_set("@#{resource_name}", resource_name.capitalize.constantize.find_by(id: params[:id]))
    unless instance_variable_get("@#{resource_name}")
      redirect_to send("#{resource_name.pluralize}_path"), alert: "指定された#{resource_name}は存在しません。"
    end
  end

  def authorize_resource!(resource)
    unless instance_variable_get("@#{resource}").user == current_user
      redirect_to send("#{resource.pluralize}_path"), alert: '権限がありません。'
    end
  end

  private

  def reset_guest_session
    session[:search_query] = nil
    # その他のセッション情報のリセットが必要な場合、ここに追加
  end

  def clear_guest_reviews(user)
    user.reviews.destroy_all
    # 必要に応じて他の関連データの削除も追加
  end

  def render_404
    render template: "errors/404", status: 404
  end

  def render_500(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")
    render template: "errors/500", status: 500
  end

  # ログイン後にリダイレクトされるパスを指定
  def after_sign_in_path_for(resource)
    search_videos_path
  end

  # パスワードリセット後にリダイレクトされるパスを指定
  def after_resetting_password_path_for(resource)
    new_user_session_path
  end
end
