class PagesController < ApplicationController
  def home
    @themes = Document::THEMES.sort
  end

  def tree_diagram
    @folders = policy_scope(Folder).includes(document_folders: :document).order(:title)
    @documents_not_classified = policy_scope(Document).where.not(id: DocumentFolder.pluck(:document_id))
  end
end
