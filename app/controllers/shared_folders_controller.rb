class SharedFoldersController < ApplicationController
  include ListHelper

  before_action :find_folder, only: %i[new create]

  def new
    @shared_folder = @folder.shared_folders.new(user: current_user)
    authorize @shared_folder
    @shared_folder.build_custom_mail
    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("add_folder_to_shared_folder", partial: "folders/add_to_shared_folder_modal", locals: {folder: @folder, shared_folder: @shared_folder}),
          turbo_stream.action(:open_modal, ".modal#addFolderToSharedFolder")
        ]
      end
    end
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
      @message = "Votre dossier a bien été envoyé."
      respond_to do |format|
        format.html { redirect_to folder_path(@folder), flash: { validation_message: true, message: @message } }
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("new_shared_folder", partial: "shared_folders/form", locals: {folder: @folder, shared_folder: @shared_folder}),
          ]
        end
      end
    end
  end

  private

  def find_folder
    @folder = Folder.find(params[:id])
  end

  def shared_folder_params
    params.require(:shared_folder).permit(:validity, :download, custom_mail_attributes: [:subject, :body, :signature])
  end

  def contacts_params
    params.require(:shared_folder).permit(contacts: [:email])
  end
end
