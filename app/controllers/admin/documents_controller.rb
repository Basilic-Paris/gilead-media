class Admin::DocumentsController < ApplicationController
  before_action :find_document, only: %i[edit update destroy attach_to_folder unactive active archive]

  def unactive
    if @document.unactive!
      redirect_to document_path(@document)
    else
      flash.now.alert = "Une erreur est survenue; ce document ne peut pas être désactivé."
      @document = @document.decorate
      @shared_document = SharedDocument.new
      @shared_list = SharedList.new
      @document_shared_list = DocumentSharedList.new
      render "documents/show"
    end
  end

  def active
    if @document.active!
      redirect_to document_path(@document)
    else
      flash.now.alert = "Une erreur est survenue; ce document ne peut pas être mis en ligne."
      @document = @document.decorate
      @shared_document = SharedDocument.new
      @shared_list = SharedList.new
      @document_shared_list = DocumentSharedList.new
      render "documents/show"
    end
  end

  def archive
    if @document.archive!
      redirect_to document_path(@document)
    else
      flash.now.alert = "Une erreur est survenue; ce document ne peut pas être archivé."
      @document = @document.decorate
      @shared_document = SharedDocument.new
      @shared_list = SharedList.new
      @document_shared_list = DocumentSharedList.new
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
      respond_to do |format|
        format.html { render :new }
        format.turbo_stream { render :validation_errors }
      end
    end
  end

  def edit
    @document.theme = nil if @document.theme == "Sans thème"
  end

  def update
    if @document.update(document_params)
      redirect_to document_path(@document)
    else
      respond_to do |format|
        format.html { render :edit }
        format.turbo_stream { render :validation_errors }
      end
    end
  end

  def destroy
    @document.destroy
    respond_to do |format|
      format.html {
        redirect_to documents_path, { flash: { validation_message: true, message: "Le document a bien été supprimé." } }
      }
      format.turbo_stream {
        flash[:validation_message] = true
        flash[:message] = "Le document a bien été supprimé."
        render turbo_stream: turbo_stream.action(:redirect, documents_path)
      }
    end
  end

  def attach_to_folder
    @shared_list = SharedList.new
    @document_shared_list = DocumentSharedList.new
    if @document.update(folder_params)
      respond_to do |format|
        format.html { redirect_to document_path(@document), flash: { validation_message: true, message: "Votre document a bien été ajouté au(x) dossier(s)." } }
        format.turbo_stream { @message = "Votre document a bien été ajouté au(x) dossier(s)." }
      end
    else
      respond_to do |format|
        format.html { render 'documents/add_to_shared_list_or_folder' }
        format.turbo_stream { render turbo_stream: [
          turbo_stream.replace("add_document_to_folder", partial: "admin/documents/attach_to_folder_form", locals: {document: @document}),
        ]}
      end
    end
  end

  private

  def document_params
    params.require(:document).permit(:title, :language, :theme, :usage, :tag_list, attachments: [])
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
