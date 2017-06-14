class Article < ApplicationRecord
     validates :subject, presence: true,
                        length: { minimum: 5, maximum: 90 }
     validates :text, presence: true,
                         length: {minimum: 25}
end
