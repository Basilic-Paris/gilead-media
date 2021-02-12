class SharedFoldersController < ApplicationController
  include ListHelper

  before_action :find_folder, only: %i[create]

  def create
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
      redirect_to folders_path, flash: { validation_message: true, message: "Votre dossier a bien été envoyé." }
    else
      flash.now[:errors_create_shared_folder] = true
      render 'folders/index'
    end
  end

  private

  def find_folder
    @document = Folder.find(params[:folder_id]).decorate
  end

  def shared_folder_params
    params.require(:shared_folder).permit(:validity, :download)
  end

  def contacts_params
    params.require(:shared_folder).permit(contacts: [:email])
  end
end
