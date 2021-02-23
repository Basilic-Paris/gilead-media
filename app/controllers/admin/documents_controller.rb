class Admin::DocumentsController < ApplicationController
  before_action :find_document, only: %i[edit update add_to_folder]
  before_action :find_document_with_document_id, only: %i[validate]

  def validate
    @document.validation_at = DateTime.now
    if @document.save
      redirect_to documents_path
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
      redirect_to document_path(@document)
    else
      render :show
    end
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
