class Public::DocumentsController < ApplicationController
  skip_before_action :authenticate_user!, only: :show
  skip_after_action :verify_authorized, only: :show
  before_action :find_shared_list, :find_document, only: :show
  layout "public"

  def show
  end

  private

  def find_shared_list
    @shared_list = SharedList.find_by(code: params[:shared_list_code])
  end

  def find_document
    @document = Document.find(params[:id]).decorate
  end
end
