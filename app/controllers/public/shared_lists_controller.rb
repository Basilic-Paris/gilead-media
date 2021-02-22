class Public::SharedListsController < ApplicationController
  skip_before_action :authenticate_user!, only: :show
  before_action :find_shared_list, only: :show
  layout "public"

  def show
    @documents = DocumentDecorator.decorate_collection(@shared_list.documents.validated)
    @folders = @shared_list.folders.with_validated_documents
  end

  private

  def find_shared_list
    @shared_list = SharedList.find_by(code: params[:code])
    authorize([:public, @shared_list])
  end
end
