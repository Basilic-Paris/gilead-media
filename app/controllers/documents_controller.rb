class DocumentsController < ApplicationController
  include ListHelper

  before_action :find_document, only: %i[show]
  before_action :disable_turbolinks_cache, only: %i[index]

  def show
    @shared_document = SharedDocument.new
    @shared_list = SharedList.new
    @document_shared_list = DocumentSharedList.new
  end

  def index
    @documents = policy_scope(Document).includes(:folders, attachment_attachment: :blob, document_folders: :folder)
    @shared_document = SharedDocument.new
    @shared_list = SharedList.new
    @document_shared_list = DocumentSharedList.new

    if search_params.present?
      search_params.reject { |key, value| value.blank? || key == "title" }.each do |key, value|
        if key == "created_at"
          @documents = @documents.created_in_days_range(value.split(" au ").first.to_date, value.split(" au ").last.to_date)
        else
          @documents = @documents.advanced_search(key, value)
        end
      end
      if search_params[:title].present?
        @documents = (@documents.advanced_search(:title, search_params[:title]) + @documents.tagged_with(arrange_list(search_params[:title]), any: true)).uniq
      else
        @documents
      end
    else
      @documents
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
    params.fetch(:search, {}).permit(:title, :format, :language, :created_at)
  end

  # TO KEEP: initial version to add folders or documents to shared list directly
  # def shared_list_params
  #   params[:document][:shared_lists_attributes].keys.each do |key|
  #     params[:document][:shared_lists_attributes][key]["user_id"] = current_user.id.to_s
  #   end
  #   params.require(:document).permit(shared_list_ids: [], shared_lists_attributes: [:title, :user_id])
  # end
end
