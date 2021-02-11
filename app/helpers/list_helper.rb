module ListHelper
  def arrange_list(list)
    list.split(/\s{1,}*[,;\/]\s{1,}*|\s{1,}/).uniq
    # \s{1,}*[,;\/]\s{1,}* (, ; ou / précédé et optionnellement précédé par un ou plusieurs espaces OU un ou plusieurs espaces
  end
end
