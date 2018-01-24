#!/usr/bin/python
#
# Generate one-time chart for use in Goldibox UI
#
# Run on command line:
# env QUERY_STRING='w=100&h=50&r=42' ./templates/uichart.png.cgi

import cgi, cgitb, rrdtool, os, tempfile, sys
try:
    from goldibox import Config
except ImportError as e:
    # If running from the git tree, try adding the lib path
    path = os.path.join(os.path.dirname(__file__),'..','..','lib','python')
    sys.path.append(path)
    from goldibox import Config

# Get and check form data
form = cgi.FieldStorage()
if 'w' not in form or 'h' not in form:
    raise RuntimeError("Please supply 'w' and 'h' CGI arguments")

# Read config
config = Config()

# Check RRD file exists
if not os.path.exists(config.rrd_file):
    raise RuntimeError("RRD database missing at '%s'" % config.rrd_file)

# Get a temporary file
f, rrdtool_graph = tempfile.mkstemp(
    suffix='.png', prefix='uichart', dir=config.rrd_image_dir)
os.close(f) # Just need the name, not the file descriptor

ret = rrdtool.graph(
    rrdtool_graph,
    "--only-graph",
    "--start=-1d",
    "--width=%s" % form['w'].value, "--height=%s" % form['h'].value,

    # Background:  stacked
    # - Too hot:  red (bottom); bogus value for label
    "--color=CANVAS#ff0000",
    "DEF:too-hot=%s:max:AVERAGE" % (config.rrd_file),
    "AREA:too-hot#ff0000",
    # - Goldilocks zone:  green (middle)
    "DEF:goldilocks=%s:max:AVERAGE" % (config.rrd_file),
    "AREA:goldilocks#00ff00",
    # - Too cold:  blue (top)
    "DEF:too-cold=%s:min:AVERAGE" % (config.rrd_file),
    "AREA:too-cold#0000ff",

    # Temp curves:  these rely on stacking
    # - External temp:  dashed black curve
    "DEF:ext=%s:ext:AVERAGE" % (config.rrd_file),
    "LINE:ext#000000:dashes",
    # - Off:  green curve (bottom)
    "DEF:int=%s:int:AVERAGE" % (config.rrd_file),
    "LINE:int#00c000",
    # - Heat:  red curve
    "DEF:heat=%s:heat:AVERAGE" % (config.rrd_file),
    "CDEF:heat-on=heat,0.01,GT",
    "CDEF:int-heat=heat-on,int,UNKN,IF",
    "LINE:int-heat#c00000",
    # - Cool:  blue curve
    "DEF:cool=%s:cool:AVERAGE" % (config.rrd_file),
    "CDEF:cool-on=cool,0.01,GT",
    "CDEF:int-cool=cool-on,int,UNKN,IF",
    "LINE:int-cool#0000c0",
    # - Disable: black curve
    "DEF:enable=%s:enable:AVERAGE" % (config.rrd_file),
    "CDEF:disable=enable,0.01,LT",
    "CDEF:int-disable=disable,int,UNKN,IF",
    "LINE5:int-disable#000000",
    # - Error and enabled:  yellow area
    "DEF:error=%s:error:AVERAGE" % (config.rrd_file),
    #     ((error>0.01) - disable) > 0
    "CDEF:error-on=error,0.01,GT,disable,-,0,GT",
    "CDEF:int-error=error-on,int,UNKN,IF",
    "AREA:int-error#ffff00",
)

with open(rrdtool_graph, 'r') as f:
    sys.stdout.write("Content-type: image/png\n\n")
    sys.stdout.write(f.read())
os.unlink(rrdtool_graph)
