class Public::SharedFoldersController < ApplicationController
  skip_before_action :authenticate_user!, only: :show
  skip_after_action :verify_authorized, only: :show
  before_action :find_shared_folder, only: :show
  layout "public"

  def show
    if @shared_folder.contacts_added? && (@shared_folder.validity.present? ? Date.today <= @shared_folder.validity : true)
      @folder = @shared_folder.folder
    else
      redirect_to root_path
    end
  end

  private

  def find_shared_folder
    @shared_folder = SharedFolder.find_by(code: params[:code])
  end
end
