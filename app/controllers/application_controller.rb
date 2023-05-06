class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: [:top, :about]
  #ユーザがログインしているかどうかを確認し、ログインしていない場合はユーザをログインページにリダイレクトする。
  before_action :configure_permitted_parameters, if: :devise_controller?
  #deviseのコントローラーだったらすべてのアクションの前にconfigure_permitted_parametersを呼ぶ

  private

  def after_sign_in_path_for(resource)
    user_path(current_user)
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email])
  end
end
