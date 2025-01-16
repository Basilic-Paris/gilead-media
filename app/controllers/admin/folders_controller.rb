class Admin::FoldersController < ApplicationController
  before_action :disable_turbo_cache, only: %i[destroy]

  def destroy
    @folder = Folder.find(params[:id])
    authorize([:admin, @folder])
    @folder.destroy
    redirect_to folders_path, { flash: { validation_message: true, message: "Le dossier a bien été supprimé." } }
  end
end
