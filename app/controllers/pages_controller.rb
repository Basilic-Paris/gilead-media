class PagesController < ApplicationController
  # skip_before_action :authenticate_user!, only: [ :home ]

  def home
    if current_user.admin?
      @documents = policy_scope(Document)
    else
      @documents = policy_scope(Document).validated
    end
  end
end
