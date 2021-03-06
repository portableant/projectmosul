class Asset < ActiveRecord::Base
  belongs_to :artefact
  has_attached_file :image, :styles => { square: "600x360#", medium: "300x300>", thumb: "100x100>" }, default_url: "/assets/:style/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  scope :assigned_to_artefact, -> { where("artefact_id IS NOT NULL") }
  scope :unassigned_to_artefact, -> { where("artefact_id IS NULL") }
  scope :unmasked, -> { where("masked_image_file_name IS NULL") }
  scope :masked, -> { where("masked_image_file_name IS NOT NULL") }

  def self.next(record)
    unassigned_to_artefact.where("id > ?", record.id).limit(1).order("id ASC").first
  end

  def self.previous(record)
    unassigned_to_artefact.where("id < ?", record.id).limit(1).order("id DESC").first
  end

  def next
    Image.next(self)
  end

  def previous
    Image.previous(self)
  end
end