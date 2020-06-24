#!/usr/local/bin/python3

from __future__ import print_function  #allows print as function

def parse_positional_args():
    "parse the command line parameters of this program"
    import argparse, collections
    parser = argparse.ArgumentParser()
    for tuple in [
            ("sheet_id",      "can topo sheet id, eg 82N7 ",  1),
            ("trunc_utm",     "truncated UTM Coordinate assuming zone 11U",  1),
            ]:
        parser.add_argument(tuple[0], help=tuple[1], nargs=tuple[2]),
    args = parser.parse_args()
    return (args.trunc_utm[0], args.sheet_id[0])


if __name__ == '__main__': 
    import sys, os, re, csv, functools, collections

    # find python modules on mac,linux and windows laptops
    for dir in ['/home/matz/goit/dcs-grade-file-scripts/',
                '/Users/mzaleski/git/dcs-grade-file-scripts' ]:
        sys.path.append(dir)

    (trunc_utm, sheet_id) = parse_positional_args()

    print(trunc_utm, sheet_id)

    # turn on branch road (moberly desc)
    # trunc UTM: 051912
    # Left hand corner of sheet 82:N/7
    # 11U  501000m.E 5679000m.N
    #       01 bold    79 bold
    # 11U  5---00    56---00
    # UTM: 11U  0505100 5691200    just 

    # LSD/pearl
    # trunc UTM: 983716
    # left hand corner of sheet 82:N/3
    # 11U  466000m.E. 5651000m.N
    #        66 bold     51 bold
    # 11U  4---00 56---00
    # 11U  498300 5671600
    # checks out: https://www.gaiagps.com/map/?loc=12.9/-117.0507/51.1931&popupLoc=-117.02466/51.19576&pubLink=8RWSlp3f4rCMj1p6ariByjrQ&waypointId=5c9187cf-1811-40c8-b88b-4ea29450e62f

    # look up sheet id in form 82N7 to UTM of lower left
    
    ll = {
        "82N7": ["11U",  "501000", "5679000"],
        "82N3": ["11U",  "466000", "5651000"],
        }

    if sheet_id in ll:
        print( ll[sheet_id] )
    else:
        print("unknown cantopo sheet id", sheet_id)
        exit(2)
    
    def xx(dict,t_utm, sheet):
        assert(len(t_utm) == 6)
        zone = dict[sheet][0]
        print("zone", zone)
        easting_base = dict[sheet][1]
        print("easting_base", easting_base)
        northing_base = dict[sheet][2]
        print("northing_base", northing_base)

        # three chars of easting, northing from truncated UTML
        t_easting = t_utm[0:3]
        print("t_easting",t_easting)
        t_northing = t_utm[3:6]
        print("t_northing",t_northing)

        # need to prepend 
        easting_prefix = easting_base[0:1]
        northing_prefix = northing_base[0:2]
        print("easting_prefix",easting_prefix)
        print("northing_prefix",northing_prefix)
        #print( "%s %s||(%s,%s)(%s,%s)\n" % (zone, t_utm, easting_prefix, northing_prefix, t_easting, t_northing) )
        utm = "%s %s%s00 %s%s00" % (zone, easting_prefix, t_easting, northing_base[0:1], t_northing)
        return utm
    
    print(xx(ll,trunc_utm,sheet_id))

