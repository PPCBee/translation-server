class Translation < ActiveRecord::Base
  belongs_to :key
  belongs_to :locale

  validates :key, uniqueness: { scope: :locale }
  validates :key, :locale, presence: true

  def self.resolve(params)
    where(key: params[:key], locale: params[:locale]).first_or_initialize
  end

  def to_s
    text
  end

  def parsed_text
    if key.array?
      YAML.load(text) || []
    else
      text
    end
  end

  def full_array
    [locale.to_s] + key.key.split('.') + [parsed_text]
  end

  def to_h
    hierarchical_hash_from_array(full_array)
  end

  def hierarchical_hash_from_array(array_hierarchy, hash_hierarchy = {})
    return hash_hierarchy if array_hierarchy.empty?

    if hash_hierarchy.empty?
      value = array_hierarchy.pop
      hash_hierarchy.merge!(array_hierarchy.pop => value)
    else
      hash_hierarchy = { array_hierarchy.pop => hash_hierarchy }
    end

    return hierarchical_hash_from_array(array_hierarchy, hash_hierarchy)
  end
end
