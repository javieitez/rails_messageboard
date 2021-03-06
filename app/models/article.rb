class Article < ApplicationRecord
    belongs_to :user
    default_scope -> { order(created_at: :desc) }
    validates :user_id, presence: true
    validates :subject, presence: true,
                      length: { minimum: 5, maximum: 90 },
                       format: { without: /((.)\2{7,})/, 
                       message: "contains too many repeated characters" }
    validates :text, presence: true,
                       length: {minimum: 25, maximum: 40000}
    mount_uploader :picture, PictureUploader
    

  def next
    self.class.where("created_at > ?", created_at).last
  end

  def previous
    self.class.where("created_at < ?", created_at).first
  end

  private
  
    # Validates the size of an uploaded picture.
    def picture_size
      if picture.size > 2.megabytes
        errors.add(:picture, "should be less than 2MB")
      end
    end

end