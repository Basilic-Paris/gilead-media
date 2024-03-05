class FoldersController < ApplicationController
  require 'zip'
  require 'tempfile'

  skip_before_action :authenticate_user!, only: :download
  before_action :find_folder, only: %i[show download add_to_shared_list attach_to_new_shared_list attach_to_existing_shared_list]
  before_action :find_shared_list, only: %i[show download]
  before_action :find_documents, only: %i[show download]
  before_action :disable_turbolinks_cache, only: %i[index show]

  def index
    @folders = policy_scope(Folder)
    @shared_list = SharedList.new
    @folder_shared_list = FolderSharedList.new
    @shared_folder = SharedFolder.new
  end

  def show
    unless @shared_list.present?
      @shared_list = SharedList.new
      @folder_shared_list = FolderSharedList.new
      @shared_folder = SharedFolder.new
    end
  end

  def add_to_shared_list
    @shared_list = SharedList.new
    @folder_shared_list = FolderSharedList.new
  end

  def attach_to_new_shared_list
    @shared_list = current_user.shared_lists.new(shared_list_params)
    @shared_list.code = SecureRandom.alphanumeric(16)
    @folder_shared_list = @shared_list.folder_shared_lists.new(folder: @folder)
    if @shared_list.save
      respond_to do |format|
        format.html { redirect_to folders_path, flash: { validation_message: true, message: "Votre liste de partage a bien été créée et votre dossier a bien été ajouté à celle-ci." } }
        format.js { @message = "Votre liste de partage a bien été créée et votre dossier a bien été ajouté à celle-ci." }
      end
    else
      render :add_to_shared_list
    end
  end

  def attach_to_existing_shared_list
    @shared_list = current_user.shared_lists.initial.first
    @folder_shared_list = @folder.folder_shared_lists.new(folder_shared_list_params)
    if @folder_shared_list.save
      respond_to do |format|
        format.html { redirect_to folders_path, flash: { validation_message: true, message: "Votre dossier a bien été ajouté à la liste de partage." } }
        format.js { @message = "Votre dossier a bien été ajouté à la liste de partage." }
      end
    else
      render :add_to_shared_list
    end
  end

  # TO KEEP: initial version to add folders or documents to shared list directly
  # def add_to_shared_list
  #   if @folder.update(shared_list_params)
  #     redirect_to folders_path
  #   else
  #     render :show
  #   end
  # end

  def download
    # create folder that will contain documents
    zip_filename = "#{@folder.title}.zip"
    zip_temp_file = Tempfile.new(zip_filename, Rails.root.join('tmp'))
    temp_document_files = []

    begin
      # initialize zip_temp_file // seems working without it
      # Zip::OutputStream.open(zip_temp_file) { |zos| }

      #Add files to the zip
      Zip::File.open(zip_temp_file.path, Zip::File::CREATE) do |zip|
        @documents.each do |document|
          document.attachments.each do |attachment|
            # temp_document_file = Tempfile.new([document.title, document.attachment_extension], Rails.root.join('tmp'))
            temp_document_file = Tempfile.new("#{document.title}_#{attachment.filename}", Rails.root.join('tmp'))

            temp_document_files << temp_document_file
            temp_document_file.binmode
            temp_document_file.write(attachment.download)
            temp_document_file.close
            # temp_document_file.path

            zip.add("#{document.title}_#{attachment.filename}", File.join(temp_document_file.path))
          end
        end
      end

      #Read the binary data from the file
      zip_data = File.read(zip_temp_file.path)

      #Send the data to the browser as an attachment
      #We do not send the file directly because it will get deleted before rails actually starts sending it
      send_data(File.read(zip_temp_file.path), type: 'application/zip', disposition: 'attachment', filename: zip_filename)

    ensure
      zip_temp_file.close
      zip_temp_file.unlink
    end

    # unlink the temp_document_files to delete them from folder Temp
    temp_document_files.each do |temp_document_file|
      temp_document_file.unlink
    end
  end

  private

  def find_folder
    @folder = Folder.find(params[:id])
    authorize @folder
  end

  def find_documents
    ordered_aasm_states = Document.aasm.states.map(&:name).map(&:to_s)
    if @shared_list.present? || current_user.blank? || (current_user.present? && !current_user.admin?)
      @documents = DocumentDecorator.decorate_collection(@folder.documents.active).sort_by { |document| ordered_aasm_states.index(document.aasm_state) }
    else
      @documents = DocumentDecorator.decorate_collection(@folder.documents).sort_by { |document| ordered_aasm_states.index(document.aasm_state) }
    end
  end

  def find_shared_list
    @shared_list = SharedList.find(params[:shared_list_id]) if params[:shared_list_id].present?
  end

  def folder_shared_list_params
    params.require(:folder_shared_list).permit(:shared_list_id)
  end

  def shared_list_params
    params.require(:shared_list).permit(:title, :validity, :download)
  end

  # TO KEEP: initial version to add folders or documents to shared list directly
  # def shared_list_params
  #   params[:folder][:shared_lists_attributes].keys.each do |key|
  #     params[:folder][:shared_lists_attributes][key]["user_id"] = current_user.id.to_s
  #   end
  #   params.require(:folder).permit(shared_list_ids: [], shared_lists_attributes: [:title, :user_id])
  # end
end
