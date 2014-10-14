require 'net/sftp'

#src info
sip="10.1.7.38"
suser="root"
spw="rootroot"
spcap="/opt/bpc/var/store/trace_archive/app11/intf1/"

#dst info
dip="10.200.44.1"
duser="root"
dpw="root"
dpcap="/home/wrt/pcap/"

#local info
lpcap="D:\\workspace_ruby\\sftp\\pcap\\"

#filename
prefix="app11_intf1_"
mid="20131115112200"
suffix=".tmp.pcap"
filename=prefix+mid+suffix


#download from src machine
Net::SFTP.start(sip, suser, :password=>spw) do |sftp|
	sftp.download!(spcap + "app11_intf1_20131115112200.tmp.pcap", lpcap + "app11_intf1_20131115112200.tmp.pcap")
end