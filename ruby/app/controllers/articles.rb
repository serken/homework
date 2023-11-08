class ArticleController
  def create_article(article)
    articles = Article.where(:title => article['title'])

    return { ok: false, msg: 'Article with given title already exists' } if articles.any?

    new_article = Article.new(:title => article['title'], :content => article['content'], :created_at => Time.now)
    new_article.save

    { ok: true, obj: new_article }
  rescue StandardError
    { ok: false }
  end

  def update_article(id, new_data)

    article = Article.where(id: id).first

    return { ok: false, msg: 'Article updated' } if article.nil?

    article.title = new_data['title']
    article.content = new_data['content']
    article.save

    { ok: true, obj: article}
  rescue StandardError
    { ok: false, msg: 'Article not found' }
  end

  def get_article(id)
    res = Article.where(:id => id).first

    if res.present?
      { ok: true, data: res }
    else
      { ok: false, msg: 'Article not found' }
    end
  rescue StandardError
    { ok: false }
  end

  def delete_article(id)
    count = Article.where(id: id).count

    if count != 0
      Article.delete(:id => id)
      { ok: true, delete_count: count }
    else
      { ok: false }
    end

  end

  def get_batch
    res = Article.limit(3) # 3 in tests?

    if res.present?
      { ok: true, data: res }
    else
      { ok: false, msg: 'Article not found' }
    end
  rescue StandardError
    { ok: false }
  end
end
