class DocumentsController < ApplicationController
  def show
    @document = Document.find(params[:id]).decorate
    authorize @document
  end

  def index
    @documents = policy_scope(Document)
    if search_params.present?
      search_params.each do |key, value|
        if key != :created_at
          @documents = @documents.advanced_search(key.to_sym, value)
        else
          @documents = @documents.created_in_days_range(value.first, value.last)
        end
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
    search = Hash.new
    search[:title] =  params[:title] if params[:title].present?
    search[:format] = params[:fmt] if params[:fmt].present?
    search[:language] = params[:language] if params[:language].present?
    search[:created_at] = params[:created_at].split(" au ").map { |date| date.to_date } if params[:created_at].present?
    return search
  end
end
