class Book < ApplicationRecord
    belongs_to :user
    belongs_to :category

    has_attached_file :avatar, styles: { :book_index => "250x375>", :book_show => "300x475>" }, default_url: "/images/:style/missing.png"
    validates_attachment_content_type :book_img, content_type: /\Aimage\/.*\z/
end
