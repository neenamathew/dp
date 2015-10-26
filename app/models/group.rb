class Group < ActiveRecord::Base
  has_many :user_groups
  has_many :users, through: :user_groups
  has_many :posts, dependent:   :destroy

  #validates :name, presence: true
  validates_uniqueness_of :name
  validates_length_of :name, :minimum => 3, :maximum => 15, :allow_blank => false
  before_validation :strip_whitespace

  def strip_whitespace
      self.name = self.name.strip
  end

  def self.search(search)
    public_group_id = Group.find_by(name: "public").id
    if search
      search = search.downcase.strip
      where('name LIKE ? ', "%#{search}%")
    else
      all
    end
  end

end
