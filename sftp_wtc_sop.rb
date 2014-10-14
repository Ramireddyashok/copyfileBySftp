require 'net/sftp'

#src info
sip="10.1.7.38"
suser="root"
spw="rootroot"
spcap="/opt/bpc/var/store/trace_archive/app14/intf2/"

#dst info
dip="10.200.44.1"
duser="root"
dpw="root"
dpcap="/home/wrt/pcap/"
drec="/home/wrt/"

#local info
lpcap="D:\\workspace_ruby\\sftp\\pcap\\"
lrec="D:\\workspace_ruby\\sftp\\"

#variable
filename=
line1=

#const
flag=0
flag1=0





i=0
sum=5
while i < sum do
	
today=Time.now.strftime "%Y%m%d"
today1=Time.now.strftime "%Y-%m-%d"

if File.exist?(lrec+"myfile.txt") then
	f = File.new(lrec+"myfile.txt", "a+")
	if flag == 0 then
		puts "open file\t"+lrec+"myfile.txt"
	end
	
	if f.readlines[0].chop == today then
		#if flag == 0 then
		#	puts "parse pcap in " + today1
		#end
		
		flag1=1
	else
		f.close
		b=lrec + "myfile.txt"
		File.delete(b)
		puts "chang to " + today1
		flag=0
		flag1=0
	end

	flag=1
else
	f = File.new(lrec+"myfile.txt", "w")
	f.puts(today);
	puts	"create file\t"+lrec+"myfile.txt"
	flag1=1
end


if flag1 == 1 then
	#download from src machine
	Net::SFTP.start(sip, suser, :password=>spw) do |sftp|
		entries = sftp.dir.entries(spcap).sort_by(&:name).reverse
		entries.each do |entry|
			
			if entry.name == "." || entry.name == ".."  then
				#	puts entry.name
			else
				ff=0

				
				File.readlines(lrec+"myfile.txt").each { |line| 
					
					if entry.name == line.chop  then
						ff=1		
						break
					end
				}
				
				filename=entry.name
				
				if ff == 1 then
					# puts filename + " have got"	
				else
					 f.puts(filename)
					 puts "download pcap " + filename
					 sftp.download!(spcap + filename, lpcap + filename)
					 
					 
					 f2 = File.new(lrec + filename + ".txt", "w")
					 f2.puts("success")
					 f2.close
					 #upload to dst machine
						Net::SFTP.start(dip, duser, :password=>dpw) do |sftp1|
								sftp1.upload!(lpcap + filename,dpcap + filename)
								sftp1.upload!(lrec + filename + ".txt",drec + filename + ".txt")
						end	
						
						puts "upload   pcap " + filename + " to " + dip + ":" + dpcap
		
		
					 #delete local pcap
					  File.delete(lrec + filename + ".txt")
						#File.delete(lpcap + filename)
						#puts "delete   pcap " + filename
			  		puts "\n" 
			  		break
				end
			end	
		end
	f.close
	end
end


puts "sleep 20s"
sleep 20
puts "\n" 
end