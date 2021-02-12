class FolderSharedListsController < ApplicationController
  def create
    @folders = policy_scope(Folder)
    @shared_list = SharedList.new
    @shared_folder = SharedFolder.new
    @folder = Folder.find(params[:folder_id])
    @folder_shared_list = @folder.folder_shared_lists.new(folder_shared_list_params)
    authorize @folder_shared_list
    if @folder_shared_list.save
      redirect_to folders_path, flash: { validation_message: true, message: "Votre dossier a bien été ajouté à la liste de partage." }
    else
      flash.now[:errors_attach_folder] = true
      render "folders/index"
    end
  end

  def folder_shared_list_params
    params.require(:folder_shared_list).permit(:shared_list_id)
  end
end
