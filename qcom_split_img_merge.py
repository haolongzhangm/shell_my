#!/usr/bin/python

import sys
import os

def usage():
    print("python qcom_split_img_merge.py partition.xml partition_name")
    print("example merge system img:")
    print(" python qcom_split_img_merge.py rawprogram_unsparse.xml system")
    exit(0)

if (len(sys.argv) != 3):
    usage()

if not os.path.exists(sys.argv[1]):
    print("Err: can not find partition_xml: %s" % sys.argv[1])
    usage()

lab = "label=\"%s\"" % sys.argv[2] 
print(sys.argv[1])
D = dict()
xml = open(sys.argv[1])
line = xml.readline()
offset = []
while line:
    if line.find(lab) >= 0:
        name = line.split('=')[3].split()[0]
        count = int(eval(line.split('=')[5].split()[0]))
        Btye = count * 512
        offset_i = line.split('=')[7].split()[0].split("\"")[1]
        offset.append(offset_i)
        D[name] = Btye
    line = xml.readline()
xml.close()

size = 0
print(sys.argv[2])
tmp_for_mount_img = '%s.img' % sys.argv[2]
os.system('rm %s' % tmp_for_mount_img)
out_img = open(tmp_for_mount_img, 'wb')
for i in range(len(D)):
    key = "\"%s_%d.img\"" % (sys.argv[2], i+1)
    #print D[key]
    #print key.split('\"')[1]
    offset_n = (int(offset[i]) - int(offset[0])) * 512
    print("handle %s : size %d offset = %d" % (key, D[key], offset_n))
    t_s = open(key.split('\"')[1], 'rb')
    chunk = t_s.read(D[key])
    out_img.seek(offset_n)
    out_img.write(chunk)
    size = size + D[key]
    t_s.close()
out_img.close()

#now time cover to Android fastboot able img
#command : sudo mount -t ext4 -o loop system.img  ./tmp_mount
#sudo make_ext4fs -l 3G -s -a system system_new.img /tmp_mount
os.system('sudo rm -rf ./tmp_mount')
os.system('mkdir ./tmp_mount')
mount_exec = "sudo mount -t ext4 -o loop %s ./tmp_mount" % tmp_for_mount_img
print mount_exec
os.system(mount_exec)
make_ext4fs_exec = "sudo make_ext4fs -l %d -s -a %s %s_new.img ./tmp_mount" % (size, sys.argv[2], sys.argv[2])
print make_ext4fs_exec
os.system(make_ext4fs_exec)
umount_exec = 'sudo umount %s/tmp_mount' % os.getcwd()
print umount_exec
os.system(umount_exec)
