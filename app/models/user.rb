class User
  def self.create(uid, name = "", email = "")
    return nil if uid.nil? or uid.empty?

    user = User.new(uid)
    user.name = name
    user.email = email

    user
  end


  attr_reader :uid
  attr_accessor :email, :name

  def initialize(uid)
    @uid = uid
  end

  def tester?
    Settings.testers.include? self.email
  end

end
