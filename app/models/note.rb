#
# class for the Note
#   field title - required
#   field content - required
#   field user_id - required - foreign key
#
# Relations:
#   belongs_to user
#   has_and_belongs_to_many tags
#   resourcify for the Role model
#
class Note < ApplicationRecord
  resourcify
  belongs_to :user
  has_and_belongs_to_many :tags

  validates :title, :content, :user_id, presence: true

  #
  # Add Tags for the Note
  #
  # @param [Array] atags - Array of tags to be added on the note
  #
  # @return [nil] Nothing
  #
  def add_tags(atags = [])
    return if atags.nil?

    atags.each do |tag_name|
      obj_tag = Tag.where(name: tag_name).first
      obj_tag = Tag.new(name: tag_name) if obj_tag.nil?
      self.tags << obj_tag unless self.tags.include?(obj_tag)
      obj_tag.save
    end
  end

  #
  # Remove tags from the Note
  #
  # @param [Array] atags - Array of tags to be removed from the note
  #
  # @return [nil] Nothing
  #
  def remove_tags(atags)
    return if atags.nil?

    atags.split(',').each do |tag_name|
      obj_tag = Tag.where(name: tag_name).first
      self.tags.delete(obj_tag) if self.tags.include?(obj_tag)
    end
  end
end
