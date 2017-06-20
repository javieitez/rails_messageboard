class Article < ApplicationRecord
    default_scope -> { order(created_at: :desc) }
    validates :subject, presence: true,
                      length: { minimum: 5, maximum: 90 },
                       format: { without: /((.)\2{7,})/, 
                       message: "contains too many repeated characters" }
    validates :text, presence: true,
                       length: {minimum: 25}
    mount_uploader :picture, PictureUploader

  private
  
    # Validates the size of an uploaded picture.
    def picture_size
      if picture.size > 2.megabytes
        errors.add(:picture, "should be less than 2MB")
      end
    end

end