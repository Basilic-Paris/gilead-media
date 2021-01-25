class FoldersController < ApplicationController
  def index
    @folders = policy_scope(Folder)
  end

  def show
    @folder = Folder.find(params[:id])
    authorize @folder
    current_user.admin? ? @documents = @folder.documents : @documents = @folder.documents.validated
  end
end
