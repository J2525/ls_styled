require "ls_styled/version"

module LsStyled
  def self.lsstyled(path)
    p Dir::entries(ARGV[0])
  end
end
