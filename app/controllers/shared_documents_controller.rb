class SharedDocumentsController < ApplicationController
  def create
    @shared_list = SharedList.new
    @document = Document.find(params[:document_id]).decorate
    @shared_document = @document.shared_documents.new(shared_document_params)
    authorize @shared_document
    if @shared_document.save
      redirect_to document_path(@document), flash: { validation_message: true, message: "Votre document a bien été ajouté à la liste de partage." }
    else
      flash.now[:errors_attach_document] = true
      render "documents/show"
    end
  end

  def shared_document_params
    params.require(:shared_document).permit(:shared_list_id)
  end
end
