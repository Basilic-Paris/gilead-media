module ListHelper
  def arrange_list(list)
    list.split(/[,;\/\s]*[,;\/\s][,;\/\s]*/).uniq.delete_if(&:blank?)
    # [,;\/\s]: , ou ; ou / ou espace
    # * : 0 ou plus
    # => [,;\/\s] précédé ou suivi de un ou plusieurs [,;\/\s]
  end
end
