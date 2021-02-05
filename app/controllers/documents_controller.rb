class DocumentsController < ApplicationController
  before_action :find_document, only: %i[show]

  def show
    @shared_list = SharedList.new
  end

  def index
    @documents = policy_scope(Document)
    if search_params.present?
      search_params.reject { |key, value| value.blank? }.each do |key, value|
        key == :created_at ? @documents = @documents.created_in_days_range(value.first, value.last) : @documents = @documents.advanced_search(key, value)
      end
    else
      @documents
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  # TO KEEP: initial version to add folders or documents to shared list directly
  # def add_to_shared_list
  #   if @document.update(shared_list_params)
  #     redirect_to document_path(@document)
  #   else
  #     render :show
  #   end
  # end

  private

  def find_document
    @document = Document.find(params[:id]).decorate
    authorize @document
  end

  def search_params
    params.fetch(:search, {}).permit(:title, :fmt, :language, :created_at)
  end

  # TO KEEP: initial version to add folders or documents to shared list directly
  # def shared_list_params
  #   params[:document][:shared_lists_attributes].keys.each do |key|
  #     params[:document][:shared_lists_attributes][key]["user_id"] = current_user.id.to_s
  #   end
  #   params.require(:document).permit(shared_list_ids: [], shared_lists_attributes: [:title, :user_id])
  # end
end
