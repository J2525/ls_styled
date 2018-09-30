require "ls_styled/version"

module LsStyled
  def self.lsstyled
    Kernel.exec('ls')
  end
end
