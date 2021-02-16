class Public::SharedListsController < ApplicationController
  skip_before_action :authenticate_user!, only: :show
  skip_after_action :verify_authorized, only: :show
  before_action :find_shared_list, only: :show
  layout "public"

  def show
    if @shared_list.contacts_added? && (@shared_list.validity.present? ? Date.today <= @shared_list.validity : true)
      @documents = DocumentDecorator.decorate_collection(@shared_list.documents.validated.includes(attachment_attachment: :blob))
      @folders = @shared_list.folders.with_validated_documents
    else
      redirect_to root_path
    end
  end

  private

  def find_shared_list
    @shared_list = SharedList.find_by(code: params[:code])
  end
end
