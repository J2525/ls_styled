require "ls_styled/version"

module LsStyled
  def self.lsstyled(path)
    lists = Dir::entries(path)
    lists.each do |list|
      next if list[0] == '.'
      puts list
    end
  end
end
