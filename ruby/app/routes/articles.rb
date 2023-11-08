require_relative '../controllers/articles'

class ArticleRoutes < Sinatra::Base
  use AuthMiddleware

  def initialize
    super
    @articleCtrl = ArticleController.new
  end

  before do
    content_type :json
  end

  get('/') do
    summary = @articleCtrl.get_batch

    if (summary[:ok])
      print(summary)
      { articles: summary[:data] }.to_json
    else
      { msg: 'Could not get articles.', articles: [] }.to_json
    end
  end

  get('/:id') do
    summary = @articleCtrl.get_article(params['id'])

    if summary[:ok]
      { msg: 'Article updated', data: summary[:data], article: summary[:data] }.to_json
    else
      { msg: summary[:msg] }.to_json
    end
  end

  post('/') do
    payload = JSON.parse(request.body.read)
    summary = @articleCtrl.create_article(payload)

    if summary[:ok]
      { msg: 'Article created' }.to_json
    else
      { msg: summary[:msg] }.to_json
    end
  end

  put('/:id') do
    payload = JSON.parse(request.body.read)
    summary = @articleCtrl.update_article params['ids'], payload

    if summary[:ok]
    else
      { msg: summary[:msg] }.to_json
    end
  end

  delete('/:id') do
    summary = @articleCtrl.delete_article params['id']

    if summary[:ok]
      { msg: 'Article deleted' }.to_json
    else
      { mgs: 'Article does not exist', 'msg' => "Article does not exist" }.to_json # ?
    end
  end
end
