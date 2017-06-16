require 'test_helper'

class ArticleTest < ActiveSupport::TestCase

  def setup
      @invalid_subject = "1234"
      @invalid_text = "123456789_123456789_1234"
      @valid_subject = "a string longer than 5 characters"
      @valid_text = "a string longer than twenty five characters"
  end

  test "should save valid note" do
    article= Article.new
    article.subject = @valid_subject
    article.text = @valid_text
    assert article.save, "Cannot save a valid note"
  end
  
  test "should not save empty note" do
    article = Article.new
    assert_not article.save, "Saved an empty note"
  end

  test "should not save note with short subject" do
    article = Article.new
    article.subject = @invalid_subject
    article.text = @valid_text
    assert_not article.save, "Saved note with short subject"
  end

  test "should not save note with subject too long" do
    article = Article.new
    article.subject = @valid_subject * 3
    article.text = @valid_text
    assert_not article.save, "Saved note with subject too long"
  end

  test "should not save note with short content" do
    article = Article.new
    article.subject = @valid_subject
    article.text = @invalid_text
    assert_not article.save, "Saved note with short content"
  end

end
