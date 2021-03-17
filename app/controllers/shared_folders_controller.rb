class SharedFoldersController < ApplicationController
  include ListHelper

  before_action :find_folder, only: %i[new create]

  def new
    @shared_folder = @folder.shared_folders.new(user: current_user)
    authorize @shared_folder
    @shared_folder.build_custom_mail
  end

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
        format.html { redirect_to folder_path(@folder), flash: { validation_message: true, message: "Votre dossier a bien été envoyé." } }
        format.js { @message = "Votre dossier a bien été envoyé." }
      end
    else
      render :new
    end
  end

  private

  def find_folder
    @folder = Folder.find(params[:id])
  end

  def shared_folder_params
    params.require(:shared_folder).permit(:validity, :download, custom_mail_attributes: [:body])
  end

  def contacts_params
    params.require(:shared_folder).permit(contacts: [:email])
  end
end
