class SharedFoldersController < ApplicationController
  include ListHelper

  before_action :find_folder, only: %i[create]

  def create
    @folders = policy_scope(Folder)
    @shared_list = SharedList.new
    @folder_shared_list = FolderSharedList.new

    @shared_folder = current_user.shared_folders.new(shared_folder_params)
    @shared_folder.folder = @folder
    authorize @shared_folder
    @shared_folder.code = SecureRandom.alphanumeric(16)

    emails = arrange_list(contacts_params[:contacts][:email])
    emails.each do |email|
      @shared_folder.contacts.build(email: email)
    end

    if @shared_folder.save
      @shared_folder.add_contacts!
      @shared_folder.notify_contacts
      respond_to do |format|
        format.html { redirect_to folders_path, flash: { validation_message: true, message: "Votre dossier a bien été envoyé." } }
        format.js { @message = "Votre dossier a bien été envoyé." }
      end
    else
      flash.now[:errors_create_shared_folder] = true
      render 'folders/index'
    end
  end

  private

  def find_folder
    @folder = Folder.find(params[:folder_id])
  end

  def shared_folder_params
    params.require(:shared_folder).permit(:validity, :download)
  end

  def contacts_params
    params.require(:shared_folder).permit(contacts: [:email])
  end
end
