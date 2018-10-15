require "ls_styled/version"

module LsStyled
  def self.run(path, opts = {})
    files = self.get_files(path, opts)
    return self.l_option(files) if opts[:l]
    puts files
  end

  def self.get_files(path, opts = {})
    lists = opts[:r] ? Dir::entries(path).sort.reverse : Dir::entries(path).sort

    return lists if opts[:a]

    results = []
    lists.each do |list|
      next if list[0] == '.'
      results << list
    end
    results
  end

  def self.l_option(files)
    puts "total #{self.get_total(files)}"
    files.each do |file|
      stat = File.lstat(file)
      file_type = self.get_file_type("0%o" % stat.mode)
      permission = self.get_permission("0%o" % stat.mode)
      formattedmode = file_type + permission
      time = "#{stat.ctime.hour}:#{"%02d" % stat.ctime.min}"
      results = [
        formattedmode,
        stat.nlink,
        Etc.getpwuid(stat.uid).name,
        Etc.getgrgid(stat.gid).name,
        stat.size,
        stat.ctime.month,
        stat.ctime.day,
        time,
        file
      ]
      puts results.join(" ")

    end
  end

  def self.get_file_type(mode)
    file_type = mode[0..-4]
    result = "l" if file_type == "0120"
    result = "-" if file_type == "0100"
    result = "d" if file_type == "040"
    return result
  end

  def self.get_permission(mode)
    result = []
    permissions = []
    permissions << mode[-3]
    permissions << mode[-2]
    permissions << mode[-1]

    permissions.each do |permission|
      result << "---" if permission == "0"
      result << "--x" if permission == "1"
      result << "-w-" if permission == "2"
      result << "-wx" if permission == "3"
      result << "r--" if permission == "4"
      result << "r-x" if permission == "5"
      result << "rw-" if permission == "6"
      result << "rwx" if permission == "7"
    end
    return result.join()

  end

  def self.get_total(files)
    total = 0
    files.each do |file|
      block = File.lstat(file).blocks
      total += block
    end
    total
  end
end
