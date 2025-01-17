class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  include Pundit
  include TurboCacheControl

  # Pundit: white-list approach.
  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  # Uncomment when you *really understand* Pundit!
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  def user_not_authorized
    if controller_path.split("/").first == "public"
      flash[:alert] = "Ce lien n'est plus actif."
      redirect_to(public_root_path)
    else
      flash[:alert] = "Vous n'êtes pas autorisé à effectuer cette action."
      redirect_to(root_path)
    end
  end

  private

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end
end
