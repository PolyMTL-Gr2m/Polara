#!/usr/bin/env python3
#
#
#####################################################################
#  Filename      : ila_analze.py
#  Version       : 
#  Created On    : 2024-08-07
#  Author        : Raphael Rowley
#  Company       : Polytechnique Montreal
#  Email         : raphael.rowley@polymtl.ca
#
#  Description   : Analyzes data got from Polara testing with ILA
#
#####################################################################

import argparse
import csv

INTERVAL_SAMPLES = 25
RADIX = 'Radix - UNSIGNED'
HEADERS = ['Sample in Buffer', 'Sample in Window', 'TRIGGER', 'fpga_bridge/fpga_chip_out/serial_buffer_channel[1:0]', 'fpga_bridge/fpga_chip_out/credit_from_chip_ff[2:0]', 'fpga_bridge/fpga_chip_out/separator/D[31:0]', 'u_ila_0_data_channel_fff[1:0]', 'fpga_bridge/fpga_chip_in/credit_fifo_out[2:0]', 'u_ila_0_buffered_data[63:0]', 'u_ila_0_buffered_channel[1:0]']

ser_buff_channff0 = '0'
cred_frm_chip0 = '0'
d0 = '00000000'
channfff0 = '2'
credfifo_out0 = '0'
buff_data0 = '8083800800000000'
buff_chan0 = '0'

ser_buff_channff1 = '0'
cred_frm_chip1 = '0'
d1 = '00000000'
channfff1 = '2'
credfifo_out1 = '0'
buff_data1 = '8000000080838008'
buff_chan1 = '2'

ser_buff_channff2 = '0'
cred_frm_chip2 = '0'
d2 = '00000000'
channfff2 = '2'
credfifo_out2 = '0'
buff_data2 = '00000b0080838008'
buff_chan2 = '0'

ser_buff_channff3 = '0'
cred_frm_chip3 = '0'
d3 = '00000000'
channfff3 = '2'
credfifo_out3 = '0'
buff_data3 = '00fff10100000b00'
buff_chan3 = '2'

ser_buff_channff4 = '0'
cred_frm_chip4 = '0'
d4 = '00000000'
channfff4 = '2'
credfifo_out4 = '0'
buff_data4 = '0000000000000b00'
buff_chan4 = '0'

def packet_compare(packet, ser_buff_channff, cred_frm_chip, d, channfff, credfifo_out, buff_data, buff_chan):
    if packet == 0:
        if ser_buff_channff == ser_buff_channff0:
            if cred_frm_chip == cred_frm_chip0:
                if d == d0:
                    if channfff == channfff0:
                        if credfifo_out == credfifo_out0:
                            if buff_data == buff_data0:
                                if buff_chan == buff_chan0:
                                    return 0
                                else:
                                    print("In packet 0, buff_chan is", buff_chan, "not", buff_chan0)
                            else:
                                print("In packet 0, buff_data is", buff_data, "not", buff_data0)
                        else:
                            print("In packet 0, credfifo_out is", credfifo_out, "not", credfifo_out0)
                    else:
                        print("In packet 0, channfff is", channfff, "not", channfff0)
                else:
                    print("In packet 0, d is", d, "not", d0)
            else:
                print("In packet 0, cred_frm_chip is", cred_frm_chip, "not", cred_frm_chip0)
        else:
            print("In packet 0, ser_buff_channff is", ser_buff_channff, "not", ser_buff_channff0)
    if packet == 1:
        if ser_buff_channff == ser_buff_channff1:
            if cred_frm_chip == cred_frm_chip1:
                if d == d1:
                    if channfff == channfff1:
                        if credfifo_out == credfifo_out1:
                            if buff_data == buff_data1:
                                if buff_chan == buff_chan1:
                                    return 0
                                else:
                                    print("In packet 1, buff_chan is", buff_chan, "not", buff_chan1)
                            else:
                                print("In packet 1, buff_data is", buff_data, "not", buff_data1)
                        else:
                            print("In packet 1, credfifo_out is", credfifo_out, "not", credfifo_out1)
                    else:
                        print("In packet 1, channfff is", channfff, "not", channfff1)
                else:
                    print("In packet 1, d is", d, "not", d1)
            else:
                print("In packet 1, cred_frm_chip is", cred_frm_chip, "not", cred_frm_chip1)
        else:
            print("In packet 1, ser_buff_channff is", ser_buff_channff, "not", ser_buff_channff1)
    if packet == 2:
        if ser_buff_channff == ser_buff_channff2:
            if cred_frm_chip == cred_frm_chip2:
                if d == d2:
                    if channfff == channfff2:
                        if credfifo_out == credfifo_out2:
                            if buff_data == buff_data2:
                                if buff_chan == buff_chan2:
                                    return 0
                                else:
                                    print("In packet 2, buff_chan is", buff_chan, "not", buff_chan2)
                            else:
                                print("In packet 2, buff_data is", buff_data, "not", buff_data2)
                        else:
                            print("In packet 2, credfifo_out is", credfifo_out, "not", credfifo_out2)
                    else:
                        print("In packet 2, channfff is", channfff, "not", channfff2)
                else:
                    print("In packet 2, d is", d, "not", d2)
            else:
                print("In packet 2, cred_frm_chip is", cred_frm_chip, "not", cred_frm_chip2)
        else:
            print("In packet 2, ser_buff_channff is", ser_buff_channff, "not", ser_buff_channff2)
    if packet == 3:
        if ser_buff_channff == ser_buff_channff3:
            if cred_frm_chip == cred_frm_chip3:
                if d == d3:
                    if channfff == channfff3:
                        if credfifo_out == credfifo_out3:
                            if buff_data == buff_data3:
                                if buff_chan == buff_chan3:
                                    return 0
                                else:
                                    print("In packet 3, buff_chan is", buff_chan, "not", buff_chan3)
                            else:
                                print("In packet 3, buff_data is", buff_data, "not", buff_data3)
                        else:
                            print("In packet 3, credfifo_out is", credfifo_out, "not", credfifo_out3)
                    else:
                        print("In packet 3, channfff is", channfff, "not", channfff3)
                else:
                    print("In packet 3, d is", d, "not", d3)
            else:
                print("In packet 3, cred_frm_chip is", cred_frm_chip, "not", cred_frm_chip3)
        else:
            print("In packet 3, ser_buff_channff is", ser_buff_channff, "not", ser_buff_channff3)
    if packet == 4:
        if ser_buff_channff == ser_buff_channff4:
            if cred_frm_chip == cred_frm_chip4:
                if d == d4:
                    if channfff == channfff4:
                        if credfifo_out == credfifo_out4:
                            if buff_data == buff_data4:
                                if buff_chan == buff_chan4:
                                    return 0
                                else:
                                    print("In packet 4, buff_chan is", buff_chan, "not", buff_chan4)
                            else:
                                print("In packet 4, buff_data is", buff_data, "not", buff_data4)
                        else:
                            print("In packet 4, credfifo_out is", credfifo_out, "not", credfifo_out4)
                    else:
                        print("In packet 4, channfff is", channfff, "not", channfff4)
                else:
                    print("In packet 4, d is", d, "not", d4)
            else:
                print("In packet 4, cred_frm_chip is", cred_frm_chip, "not", cred_frm_chip4)
        else:
            print("In packet 4, ser_buff_channff is", ser_buff_channff, "not", ser_buff_channff4)

def main():

    # Init
    parser = argparse.ArgumentParser(description='Process ILA saved data.')
    parser.add_argument('-f', '--file', help='File to analyze (assumes CSV).')
    args = parser.parse_args()

    # Check inputs
    if len(args.file) < 1:
        print("Empty file provided")
        return -1
    datafile = args.file

    # Load CSV
    with open(datafile, newline='') as datacsv:
        trigreader = csv.DictReader(datacsv)

        # Find trigger
        for row in trigreader:
            if row['TRIGGER'] == '1':
                trigpoint = row['Sample in Buffer']
                print("Found trigger point, it is: ", trigpoint)
                break
        iterator = 0
        iterator1 = 0
        iterator2 = 0
        iterator3 = 0
        iterator4 = 0
        datacsv.seek(0)
        datareader = csv.DictReader(datacsv)
        print(datareader.fieldnames)
        # Analyze data
        for row in datareader:
            if row['Sample in Buffer'] != RADIX:
                if (int(row['Sample in Buffer']) >= int(trigpoint)) and (int(row['Sample in Buffer']) < int(trigpoint) + INTERVAL_SAMPLES):
                    #print("First packet", iterator, "Sample:", row['Sample in Buffer'])
                    packet_compare(0, row[HEADERS[3]], row[HEADERS[4]], row[HEADERS[5]], row[HEADERS[6]], row[HEADERS[7]], row[HEADERS[8]], row[HEADERS[9]])
                    iterator += 1
                elif (int(row['Sample in Buffer']) >= int(trigpoint) + (INTERVAL_SAMPLES)) and (int(row['Sample in Buffer']) < int(trigpoint) + (2*INTERVAL_SAMPLES)):
                    #print("Second packet", iterator1, "Sample:", row['Sample in Buffer'])
                    packet_compare(1, row[HEADERS[3]], row[HEADERS[4]], row[HEADERS[5]], row[HEADERS[6]], row[HEADERS[7]], row[HEADERS[8]], row[HEADERS[9]])
                    iterator1 += 1
                elif (int(row['Sample in Buffer']) >= int(trigpoint) + (2*INTERVAL_SAMPLES)) and (int(row['Sample in Buffer']) < int(trigpoint) + (3*INTERVAL_SAMPLES)):
                    #print("Third packet", iterator2, "Sample:", row['Sample in Buffer'])
                    packet_compare(2, row[HEADERS[3]], row[HEADERS[4]], row[HEADERS[5]], row[HEADERS[6]], row[HEADERS[7]], row[HEADERS[8]], row[HEADERS[9]])
                    iterator2 += 1
                elif (int(row['Sample in Buffer']) >= int(trigpoint) + (3*INTERVAL_SAMPLES)) and (int(row['Sample in Buffer']) < int(trigpoint) + (4*INTERVAL_SAMPLES)):
                    #print("Fourth packet", iterator3, "Sample:", row['Sample in Buffer'])
                    packet_compare(3, row[HEADERS[3]], row[HEADERS[4]], row[HEADERS[5]], row[HEADERS[6]], row[HEADERS[7]], row[HEADERS[8]], row[HEADERS[9]])
                    iterator3 += 1
                elif (int(row['Sample in Buffer']) >= int(trigpoint) + (4*INTERVAL_SAMPLES)) and (int(row['Sample in Buffer']) < int(trigpoint) + (5*INTERVAL_SAMPLES)):
                    #print("Fifth packet", iterator4, "Sample:", row['Sample in Buffer'])
                    packet_compare(4, row[HEADERS[3]], row[HEADERS[4]], row[HEADERS[5]], row[HEADERS[6]], row[HEADERS[7]], row[HEADERS[8]], row[HEADERS[9]])
                    iterator4 += 1
    
if __name__ == '__main__':

    main()

