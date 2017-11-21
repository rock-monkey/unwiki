class DB
  def self.db
    @@db ||= SQLite3::Database.new "db.sqlite3"
  end

  def self.method_missing(method, *args)
    self.db.send(method, *args)
  end
end
