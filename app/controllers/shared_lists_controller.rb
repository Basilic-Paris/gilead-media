class SharedListsController < ApplicationController
  include ListHelper
  before_action :find_shared_list, only: %i[show add_contacts]
  before_action :find_document, only: :create_and_attach_document
  before_action :new_shared_list, only: %i[create_and_attach_document]

  def index
    @shared_lists = policy_scope(SharedList)
  end

  def show
  end

  def create_and_attach_document
    @documents = policy_scope(Document).validated
    @shared_document = SharedDocument.new
    @document_shared_list = @shared_list.document_shared_lists.new(document: @document)
    if @shared_list.save
      respond_to do |format|
        format.html { redirect_to document_path(@document), flash: { validation_message: true, message: "Votre liste de partage a bien été créée et votre document a bien été ajouté." } }
        format.js { @message = "Votre liste de partage a bien été créée et votre document a bien été ajouté." }
      end
    else
      flash.now[:errors_attach_document] = true
      render 'documents/show'
    end
  end

  def add_contacts
    emails = arrange_list(contacts_params[:contacts][:email])

    emails.each do |email|
      @shared_list.contacts.build(email: email)
    end

    if @shared_list.save
      @shared_list.add_contacts!
      @shared_list.notify_contacts
      redirect_to shared_list_path(@shared_list), flash: { validation_message: true, message: "Votre liste de partage a bien été envoyée." }
    else
      render :show
    end
  end

  private

  def find_shared_list
    @shared_list = SharedList.find(params[:id])
    authorize @shared_list
  end

  def new_shared_list
    @shared_list = current_user.shared_lists.new(shared_list_params)
    authorize @shared_list
    @shared_list.code = SecureRandom.alphanumeric(16)
  end

  def find_folder
    @folder = Folder.find(params[:folder_id])
  end

  def find_document
    @document = Document.find(params[:document_id]).decorate
  end

  def contacts_params
    params.require(:shared_list).permit(contacts: [:email])
  end

  def shared_list_params
    params.require(:shared_list).permit(:title, :validity, :download)
  end
end
