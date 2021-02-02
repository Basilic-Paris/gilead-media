class SharedListsController < ApplicationController
  def index
    @shared_lists = policy_scope(SharedList)
  end

  def show
    @shared_list = SharedList.find(params[:id]).decorate
    authorize @shared_list
  end
end
