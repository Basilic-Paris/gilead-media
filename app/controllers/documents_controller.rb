class DocumentsController < ApplicationController
  def show
    @document = Document.find(params[:id]).decorate
    authorize @document
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

  private

  def search_params
    params.fetch(:search, {}).permit(:title, :fmt, :language, :created_at)
  end
end
