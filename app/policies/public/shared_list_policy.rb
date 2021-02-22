class Public::SharedListPolicy < ApplicationPolicy
  def show?
    record.contacts_added? && (record.validity.present? ? record.validity >= Date.today : true)
  end
end
