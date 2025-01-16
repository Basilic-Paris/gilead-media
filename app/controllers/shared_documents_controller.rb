class SharedDocumentsController < ApplicationController
  include ListHelper

  before_action :find_document, only: %i[new create]

  def new
    @shared_document = @document.shared_documents.new(user: current_user)
    authorize @shared_document
    @shared_document.build_custom_mail
    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("add_document_to_shared_document", partial: "documents/add_to_shared_document_modal", locals: {document: @document, shared_document: @shared_document}),
          turbo_stream.action(:open_modal, ".modal#addDocumentToSharedDocument")
        ]
      end
    end
  end

  def create
    @documents = policy_scope(Document).active
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
      @message = "Votre document a bien été envoyé."
      respond_to do |format|
        format.html { redirect_to document_path(@document), flash: { validation_message: true, message: @message } }
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("new_shared_document", partial: "shared_documents/form", locals: {document: @document, shared_document: @shared_document}),
          ]
        end
      end
    end
  end

  private

  def find_document
    @document = Document.find(params[:id]).decorate
  end

  def shared_document_params
    params.require(:shared_document).permit(:validity, :download, custom_mail_attributes: [:subject, :body, :signature])
  end

  def contacts_params
    params.require(:shared_document).permit(contacts: [:email])
  end
end
