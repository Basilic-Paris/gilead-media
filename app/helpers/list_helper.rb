module ListHelper
  def arrange_list(list)
    list.split(/\s{1,}*[,;\/]\s{1,}*|\s{1,}/).uniq
  end
end
