class Public::SharedDocumentsController < ApplicationController
  skip_before_action :authenticate_user!, only: :show
  before_action :find_shared_document, only: :show
  layout "public"

  def show
    @document = @shared_document.document.decorate
  end

  private

  def find_shared_document
    @shared_document = SharedDocument.find_by(code: params[:code])
    authorize([:public, @shared_document])
  end
end
