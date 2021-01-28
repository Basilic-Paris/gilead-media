class DocumentsController < ApplicationController
  def show
    @document = Document.find(params[:id])
    authorize @document
  end

  def index
    @documents = policy_scope(Document)
    if search_params.present?
      search_params.each do |key, value|
        if key != "created_at"
          @documents = @documents.advanced_search(key.to_sym, value)
        else
          @documents = @documents.created_in_day_range_around(value)
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
    if params[:date].present?
      if params[:date]["created_at(1i)"].present? && params[:date]["created_at(2i)"].present? && params[:date]["created_at(3i)"].present?
        search[:created_at] = Date.new(params[:date]["created_at(1i)"].to_i, params[:date]["created_at(2i)"].to_i, params[:date]["created_at(3i)"].to_i)
      end
    end
    return search
  end
end
