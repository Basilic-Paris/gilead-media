class Public::SharedFoldersController < ApplicationController
  skip_before_action :authenticate_user!, only: :show
  before_action :find_shared_folder, only: :show
  layout "public"

  def show
    @folder = @shared_folder.folder
  end

  private

  def find_shared_folder
    @shared_folder = SharedFolder.find_by(code: params[:code])
    authorize([:public, @shared_folder])
  end
end
