class Public::FoldersController < ApplicationController
  skip_before_action :authenticate_user!, only: :show
  before_action :find_shared_object, :find_folder, only: :show
  layout "public"

  def show
    @documents = DocumentDecorator.decorate_collection(@folder.documents.validated)
  end

  private

  def find_shared_object
    if params[:shared_list_code].present?
      @shared_object = SharedList.find_by(code: params[:shared_list_code])
    elsif params[:shared_folder_code].present?
      @shared_object = SharedFolder.find_by(code: params[:shared_folder_code])
    end
    authorize([:public, @shared_object], :show?)
  end

  def find_folder
    @folder = Folder.find(params[:id])
  end
end
