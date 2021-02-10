class DocumentSharedListsController < ApplicationController
  def create
    @shared_list = SharedList.new
    @document = Document.find(params[:document_id]).decorate
    @document_shared_list = @document.document_shared_lists.new(document_shared_list_params)
    authorize @document_shared_list
    if @document_shared_list.save
      redirect_to document_path(@document), flash: { validation_message: true, message: "Votre document a bien été ajouté à la liste de partage." }
    else
      flash.now[:errors_attach_document] = true
      render "documents/show"
    end
  end

  def document_shared_list_params
    params.require(:document_shared_list).permit(:shared_list_id)
  end
end
