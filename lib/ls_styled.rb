require "ls_styled/version"

module LsStyled
  def self.lsstyled(path)
    p Dir::entries(path)
  end
end
