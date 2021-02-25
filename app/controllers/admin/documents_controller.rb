class Admin::DocumentsController < ApplicationController
  before_action :find_document, only: %i[edit update destroy add_to_folder]
  before_action :find_document_with_document_id, only: %i[validate]

  def validate
    @document.validation_at = DateTime.now
    if @document.save
      redirect_to document_path(@document)
    else
      render "documents/show"
    end
  end

  def new
    @document = Document.new
    authorize([:admin, @document])
  end

  def create
    @document = Document.new(document_params)
    authorize([:admin, @document])
    if @document.save
      redirect_to document_path(@document)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @document.update(document_params)
      redirect_to document_path(@document)
    else
      render :edit
    end
  end

  def add_to_folder
    if @document.update(folder_params)
      respond_to do |format|
        format.html { redirect_to document_path(@document), flash: { validation_message: true, message: "Votre document a bien été ajouté au(x) dossier(s)." } }
        format.js { @message = "Votre document a bien été ajouté au(x) dossier(s)." }
      end
    else
      render :show
    end
  end

  def destroy
    @document.destroy
    redirect_to documents_path, { flash: { validation_message: true, message: "Le document a bien été supprimé." } }
  end

  private

  def document_params
    params.require(:document).permit(:title, :language, :usage, :attachment, :tag_list)
  end

  def folder_params
    params.require(:document).permit(folder_ids:[], folders_attributes: [:title])
  end

  def find_document
    @document = Document.find(params[:id])
    authorize([:admin, @document])
  end

  def find_document_with_document_id
    @document = Document.find(params[:document_id])
    authorize([:admin, @document])
  end
end
