#!/usr/bin/ruby

%x{echo "0. Initial state" > disk.log}
%x{du -s >> disk.log}
%x{df >> disk.log}


# %x{dd if=/dev/zero of=dummy.file  bs=1024*1024*1024 count=1}
%x{dd if=/dev/zero of=dummy.file  bs=1024 count=1}

fs = File::Stat.new("dummy.file")
ino = fs.ino
puts ino
puts "Find files from inode"
puts %x{find ./ -inum #{fs.ino}}

f = open("dummy.file")
  %x{echo "1. Before remove during open" >> disk.log}
  %x{du -s >> disk.log}
  %x{df >> disk.log}

  %x{rm dummy.file}
  puts "Find files from inode"
  puts %x{find ./ -inum #{fs.ino}}

  %x{echo "2. After remove during open" >> disk.log}
  %x{du -s >> disk.log}
  %x{df >> disk.log}
  pid = $$
  of = %x{lsof | grep dummy.file | tr -s " " | cut -d " " -f 4}
  of.gsub!(/(\d).*/,'\1')
  # Cannot hard link
  %x{cp /proc/#{pid}/fd/#{of.chomp} dummy.bak}

  %x{echo "3. After copy during open" >> disk.log}
  %x{du -s >> disk.log}
  %x{df >> disk.log}
  %x{rm dummy.bak}
f.close

%x{echo "4. After close" >> disk.log}
%x{du -s >> disk.log}
%x{df >> disk.log}
