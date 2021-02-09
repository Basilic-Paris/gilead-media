class Public::FoldersController < ApplicationController
  skip_before_action :authenticate_user!, only: :show
  skip_after_action :verify_authorized, only: :show
  before_action :find_shared_list, :find_folder, only: :show
  layout "public"

  def show
    @documents = DocumentDecorator.decorate_collection(@folder.documents.validated)
  end

  private

  def find_shared_list
    @shared_list = SharedList.find_by(code: params[:shared_list_code])
  end

  def find_folder
    @folder = Folder.find(params[:id])
  end
end
