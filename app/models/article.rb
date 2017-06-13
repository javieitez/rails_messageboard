class Article < ApplicationRecord
     validates :subject, presence: true,
                        length: { minimum: 5 }
end
