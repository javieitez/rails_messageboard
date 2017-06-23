module ArticlesHelper
  
  #searches for insanely long words
    def contains_insanely_long_words(note)
      @status = 0 
      note.split.each do |s|
        if s.length > 45 # longest word in english dictionary
          @status += 1
        end
      end
        if @status == 0 
          return false
        else
          return true
        end
    end

  def not_first(article)
  	if article.id == Article.first.id
  		return false
  	else
  	  return true
  	end
  end
  
  def not_last(article)
  	if article.id == Article.last.id
  		return false
  	else
  	  return true
  	end
  end

end

