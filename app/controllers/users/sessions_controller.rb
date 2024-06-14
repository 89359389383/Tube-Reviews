# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # DELETE /resource/sign_out
  def destroy
    if current_user.email == 'guest@example.com'
      # ゲストユーザーのデータをリセットする処理を追加
      current_user.reviews.destroy_all
      # 必要に応じて他のデータ削除処理を追加
    end
    super do
      flash[:notice] = 'ログアウトしました'
    end
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
