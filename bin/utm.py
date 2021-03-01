#!/usr/local/bin/python3
from __future__ import print_function  #allows print as function

Dbg = False


# given a canada topo sheet number stash the UTM coordinates of the LL (SW) corner.
# ie the corner with the lowest easting, northing
# we basically add the trucated utm to it.
    
map_sheet_id_to_UTM_lower_left = {
    "82N7": ["11U",  "501000", "5679000"],
    "82N3": ["11U",  "466000", "5651000"],
    "82N2": ["11U",  "501000", "5651000"],
    "82N6": ["11U",  "466000", "5679000"],
    }

def parse_positional_args():
    "parse the command line parameters of this program"
    import argparse, collections
    epilog_string='''\
    known map sheets are:
         '''
    for map in map_sheet_id_to_UTM_lower_left.keys():
        epilog_string += map + " "
    parser = argparse.ArgumentParser(epilog=epilog_string)
    for tuple in [
            ("sheet_id",      "can topo sheet id, eg 82N7 ",  1),
            ("trunc_utm",     "truncated UTM Coordinate assuming zone 11U",  1),
            ]:
        parser.add_argument(tuple[0], help=tuple[1], nargs=tuple[2]),
    args = parser.parse_args()
    return (args.trunc_utm[0], args.sheet_id[0])

# utm.py 82N7 051912
# turn on branch road (moberly desc)
# trunc UTM: 051912
# Left hand corner of sheet 82:N/7
# 11U  501000m.E 5679000m.N
#       01 bold    79 bold
# 11U  5---00    56---00
# UTM: 11U  0505100 5691200    just 

# LSD/pearl
# trunc UTM: sheet 82N3 983716
# left hand corner of sheet 82:N/3
# 11U  466000m.E. 5651000m.N
#        66 bold     51 bold
# 11U  4---00 56---00
# 11U  498300 5671600
# checks out: https://www.gaiagps.com/map/?loc=12.9/-117.0507/51.1931&popupLoc=-117.02466/51.19576&pubLink=8RWSlp3f4rCMj1p6ariByjrQ&waypointId=5c9187cf-1811-40c8-b88b-4ea29450e62f

# 82N2 ? 872701
# BTW, I think this is a bug in fabrice's site.. should be 972 easting
# LL 501000 5651000
# look up sheet id in form 82N2 to UTM of lower left 
# 501000 565100

def detruncify(dict,t_utm, sheet):
    "convert truncated UTM t_utm on sheet to universal UTM"
    assert(len(t_utm) == 6)
    zone = dict[sheet][0]
    if Dbg: print("zone", zone)
    easting_base = dict[sheet][1]
    northing_base = dict[sheet][2]
    if Dbg:
        print("easting_base", easting_base)
        print("northing_base", northing_base)
    # three chars of easting, northing from truncated UTML
    t_easting = t_utm[0:3]
    t_northing = t_utm[3:6]
    if Dbg:
        print("t_easting",t_easting)
        print("t_northing",t_northing)
    easting_prefix = easting_base[0:1]
    northing_prefix = northing_base[0:2]
    if Dbg:
        print("easting_prefix",easting_prefix)
        print("northing_prefix",northing_prefix)
    return "%s %s%s00 %s%s00" % (zone, easting_prefix, t_easting, northing_prefix, t_northing)

if __name__ == '__main__': 
    import sys, os, re, csv, functools, collections

    # # find python modules on mac,linux and windows laptops
    # for dir in ['/home/matz/goit/dcs-grade-file-scripts/',
    #             '/Users/mzaleski/git/dcs-grade-file-scripts' ]:
    #     sys.path.append(dir)

    (trunc_utm, sheet_id) = parse_positional_args()

    if Dbg: print(trunc_utm, sheet_id)

    if sheet_id in map_sheet_id_to_UTM_lower_left:
        if Dbg: print( map_sheet_id_to_UTM_lower_left[sheet_id] )
    else:
        print("cantopo sheet id", sheet_id, " has not been added to this script yet")
        print("visit:")
        print("https://ftp.maps.canada.ca/pub/nrcan_rncan/vector/index/html/geospatial_product_index_en.html")
        print("find and download the 50K map and find the UTM lower left easting,northing")
        print("\n")
        print("or, more directly, you can concoct the FTP link from the above URL and ", sheet_id)
        print("for instance, for topo sheet 82 N/6, concatenate 082/n/06")
        print("to create URL: https://ftp.maps.canada.ca/pub/nrcan_rncan/raster/topographic/50k/082/n/06/")
        print("\n")
        print("https://ftp.maps.canada.ca/pub/nrcan_rncan/raster/topographic/50k/082/n/06/082n06_0400_canmatrix_prtpdf.zip")
        print("\n")
        #url = "http://ftp.maps.canada.ca/pub/nrcan_rncan/vector/index/html/geospatial_product_index_en.html"
        url = "https://ftp.maps.canada.ca/pub/nrcan_rncan/raster/topographic/50k/082/n/06"
        import webbrowser
        print("study map and add blue easting, northing numbers to the map_sheet_id_to_UTM_lower_left table in this script")
        resp = input("open browser on ftp site URL " + url + "?  [yYnN]* > ")
        if resp.lower().startswith( 'y'):
            webbrowser.open(url)
        exit(2)
    
    utm = detruncify(map_sheet_id_to_UTM_lower_left,trunc_utm,sheet_id)
    print("copy to clipboard full UTM for sheet " + sheet_id + " grid " + trunc_utm +  " ``" + utm + "``")
    os.system("/bin/echo -n '%s' | pbcopy" % utm)

            
