class Comment
  attr_reader :id, :page_tag, :time, :comment, :user

  def self.all
    @@all_comments ||= DB.execute('SELECT * FROM wikka_comments').map{|row| Comment.new(row)}
  end

  def self.find_all_by_page_tag(page_tag)
    all.select{|comment| comment.page_tag == page_tag}
  end

  def initialize(row)
    @id, @page_tag, @time, @comment, @user = row
  end
end
