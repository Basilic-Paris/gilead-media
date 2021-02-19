class Public::SharedDocumentsController < ApplicationController
  skip_before_action :authenticate_user!, only: :show
  skip_after_action :verify_authorized, only: :show
  before_action :find_shared_document, only: :show
  layout "public"

  def show
    if @shared_document.contacts_added? && (@shared_document.validity.present? ? Date.today <= @shared_document.validity : true)
      @document = @shared_document.document.decorate
    else
      redirect_to root_path
    end
  end

  private

  def find_shared_document
    @shared_document = SharedDocument.find_by(code: params[:code])
  end
end
