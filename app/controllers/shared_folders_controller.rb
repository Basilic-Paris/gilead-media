class SharedFoldersController < ApplicationController
  def create
    @folders = policy_scope(Folder)
    @shared_list = SharedList.new
    @folder = Folder.find(params[:folder_id])
    @shared_folder = @folder.shared_folders.new(shared_folder_params)
    authorize @shared_folder
    if @shared_folder.save
      redirect_to folders_path, flash: { validation_message: true, message: "Votre dossier a bien été ajouté à la liste de partage." }
    else
      flash.now[:errors_attach_folder] = true
      render "folders/index"
    end
  end

  def shared_folder_params
    params.require(:shared_folder).permit(:shared_list_id)
  end
end
