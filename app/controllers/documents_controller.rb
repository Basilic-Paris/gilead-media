class DocumentsController < ApplicationController

  def show
    @document = Document.find(params[:id])
    authorize @document
  end

  def index
    if current_user.admin?
      @documents = policy_scope(Document)
    else
      @documents = policy_scope(Document).validated
    end
  end

end
