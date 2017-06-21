class ArticlesController < ApplicationController
  
  def create
    @article = Article.new(article_params)
 
    if @article.save
      flash[:success] = "Note Created!"
      redirect_to @article
    else
      render 'new'
    end
  
  end
  
  def show
    @article = Article.find(params[:id])
  end

  def edit
    @article = Article.find(params[:id])
  end

  def index
    @articles = Article.all.paginate(page: params[:page], :per_page => 8).order(created_at: :desc)
  end

  def show
    @article = Article.find(params[:id])
  end
  
  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    redirect_to articles_path
  end

  def update
    @article = Article.find(params[:id])
   
    
    
    if @article.update(article_params)
      flash[:success] = "Note Updated!"
      redirect_to @article
    else
      render 'edit'
    end
  end

end

private
  def article_params
    params.require(:article).permit(:subject, :text, :picture, :remove_picture)
  end
