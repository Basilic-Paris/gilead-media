class DocumentsController < ApplicationController

  def show
    @document = Document.find(params[:id])
    authorize @document
  end

  def index
    @documents = policy_scope(Document)
  end

end
