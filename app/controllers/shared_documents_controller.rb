class SharedDocumentsController < ApplicationController
  include ListHelper

  before_action :find_document, only: %i[new create]

  def new
    @shared_document = @document.shared_documents.new
    authorize @shared_document
  end

  def create
    @documents = policy_scope(Document).validated
    @shared_list = SharedList.new
    @document_shared_list = DocumentSharedList.new

    @shared_document = current_user.shared_documents.new(shared_document_params)
    @shared_document.document = @document
    authorize @shared_document
    @shared_document.code = SecureRandom.alphanumeric(16)

    emails = arrange_list(contacts_params[:contacts][:email])
    emails.each do |email|
      @shared_document.contacts.build(email: email)
    end

    if @shared_document.save
      @shared_document.add_contacts!
      @shared_document.notify_contacts
      respond_to do |format|
        format.html { redirect_to document_path(@document), flash: { validation_message: true, message: "Votre document a bien été envoyé." } }
        format.js { @message = "Votre document a bien été envoyé." }
      end
    else
      render :new
    end
  end

  private

  def find_document
    @document = Document.find(params[:id]).decorate
  end

  def shared_document_params
    params.require(:shared_document).permit(:validity, :download)
  end

  def contacts_params
    params.require(:shared_document).permit(contacts: [:email])
  end
end
