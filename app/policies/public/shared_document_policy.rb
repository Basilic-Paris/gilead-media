class Public::SharedDocumentPolicy < ApplicationPolicy
  def show?
    record.document.active? && record.contacts_added? && (record.validity.present? ? record.validity >= Date.today : true)
  end
end
