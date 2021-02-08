class SharedDocumentPolicy < ApplicationPolicy
  def create?
    user.shared_lists.initial.present? && SharedDocument.find_by(shared_list: user.shared_lists.initial, document: record.document).blank?
  end
end
