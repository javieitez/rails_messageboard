class Article < ApplicationRecord
     validates :subject, presence: true,
                        length: { minimum: 5, maximum: 90 },
                         format: { without: /((.)\2{7,})/, 
                         message: "contains too many repeated characters" }
     validates :text, presence: true,
                         length: {minimum: 25}
end