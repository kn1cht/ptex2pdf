#!/usr/bin/env texlua

NAME = "ptex2pdf[.lua]"
VERSION = "$VER$"
AUTHOR = "Norbert Preining"
AUTHOREMAIL = "norbert@preining.info"
SHORTDESC = "Convert Japanese TeX documents to pdf"
LONGDESC = [[
Main purpose of the script is easy support of Japanese typesetting
engines in TeXworks. As TeXworks typesetting setup does not allow
for multistep processing, this script runs one of the ptex based
programs (ptex, uptex, eptex, euptex, platex, uplatex) followed
by dvipdfmx.
]]
USAGE = [[
[texlua] ptex2pdf[.lua] { option | basename[.tex] } ... 
options: -v  version
         -h  help
         -help print full help (installation, TeXworks setup)
         -e  use eptex class of programs
         -u  use uptex class of programs
         -l  use latex based formats
         -s  stop at dvi
         -i  retain intermediate files
         -ot '<opts>' extra options for TeX
         -od '<opts>' extra options for dvipdfmx
         -output-directory '<dir>' directory for created files]]

LICENSECOPYRIGHT = [[
Originally based on musixtex.lua from Bob Tennent.

(c) Copyright 2016-2018 Japanese TeX Development Community
(c) Copyright 2013-2018 Norbert Preining norbert@preining.info
(c) Copyright 2012      Bob Tennent rdt@cs.queensu.ca

This program is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the
Free Software Foundation; either version 2 of the License, or (at your
option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
Public License for more details.

You should have received a copy of the GNU General Public License along
with this program; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
]]

INSTALLATION = [[
Copy the file ptex2pdf.lua into a directory where scripts are found,
that is for example

  `TLROOT/texmf-dist/scripts/ptex2pdf/`

(where `TLROOT` is for example the root of your TeX Live installation)

### Unix ###

create a link in one of the bin dirs to the above file, in the
TeX Live case:

  `TLROOT/bin/ARCH/ptex2pdf -> ../../texmf-dist/scripts/ptex2pdf/ptex2pdf.lua`

### Windows ###
create a copy of runscript.exe as ptex2pdf.exe, in the TeX Live case:

  `copy TLROOT/bin/win32/runscript.exe TLROOT/bin/win32/ptex2pdf.exe`
]]

TEXWORKS = [[
Under Preferences > Typesetting add new entries, for example:

for ptex files:

| Setting     | Value              |
|-------------|--------------------|
| Name:       | pTeX (ptex2pdf)    |
| Program:    | ptex2pdf           |
| Arguments:  | -ot                |
|             | $synctexoption     |
|             | $fullname          |

for platex files:

| Setting     | Value              |
|-------------|--------------------|
| Name:       | pLaTeX (ptex2pdf)  |
| Program:    | ptex2pdf           |
| Arguments:  | -l                 |
|             | -ot                |
|             | $synctexoption     |
|             | $fullname          |

for uptex files:

| Setting     | Value              |
|-------------|--------------------|
| Name:       | upTeX (ptex2pdf)   |
| Program:    | ptex2pdf           |
| Arguments:  | -u                 |
|             | -ot                |
|             | $synctexoption     |
|             | $fullname          |

for uplatex files:

| Setting     | Value              |
|-------------|--------------------|
| Name:       | upLaTeX (ptex2pdf) |
| Program:    | ptex2pdf           |
| Arguments:  | -l                 |
|             | -u                 |
|             | -ot                |
|             | $synctexoption     |
|             | $fullname          |

If you need special kanji encodings for one of these programs,
add the respective `-kanji` option with the `$synctexoption`. Example:

for platex files in SJIS encoding:

| Setting     | Value                      |
|-------------|----------------------------|
| Name:       | pLaTeX/SJIS (ptex2pdf)     |
| Program:    | ptex2pdf                   |
| Arguments:  | -l                         |
|             | -ot                        |
|             | -kanji=sjis $synctexoption |
|             | $fullname                  |
]]

DEVELPLACE = "http://github.com/texjporg/ptex2pdf"


CHANGELOG = [[
- version 0.1  2013-03-08 NP  
  Initial release on blog
- version 0.2  2013-03-10 NP  
  import into git repository  
  support passing options on to tex and dvipdfm  
  add README with TeXworks config options  
- version 0.3  2013-05-01 NP  
  include the readme in the lua code  
  fix program name for -e -u  
- version 0.4  2013-05-07 NP  
  quote the filename with ", so that special chars do survive  
  add an example for TeXworks for files with different kanji encoding  
- version 0.5  2014-11-05 NP  
  on Windows: set command_line_encoding to utf8 when running uptex  
  (patch by Akira Kakuto)  
- version 0.6  2015-03-08 NP  
  cygwin didn't like the (accidentally inserted) spaces after the  
  texlua in the shebang line, and stopped working with  
    "no such program: "texlua  " ..."  
- version 0.7 2015-04-29  
  move to github as gitorious will be closed, adapt help output  
  to generate github flavored markdown  
  check for files using kpathsea instead of opening directly, to allow  
  for input of files found by kpathsea (closes github issue 1)  
- version 0.8 2015-06-15  
  file name checks: first search for arg as is, then try .tex and .ltx  
  (closes github issue: 3)  
- version 0.9 2016-12-12  
  allow for files in sub-directories  
  add -output-directory option  
  update copyright and development place (now in texjp)  
  support 'flag=val' to specify option values  
  only allow one (1) filename argument  
- version 20170603.0  
  start version number in the format YYYYMMDD.0  
  better support for cp932 windows filenames  
  first replace all backslash chars to slash chars  
- version 20170622.0  
  pass all non-optional arguments before filename to TeX engine  
- version 20180514.0
  Windows: for uptex use command_line_encoding=utf8, for all other turn
  it off (set to none)
]]


function usage()
  print(USAGE)
end

function makereadme()
  print("# " .. NAME .. " #")
  print()
  print("**Author:** " .. AUTHOR .. "  ")
  print("**Website:** http://www.preining.info/blog/software-projects/ptex2pdf/ (in Japanese)  ")
  print("**License:** GPLv2")
  print()
  print(SHORTDESC)
  print()
  print("## Description ##")
  print()
  print(LONGDESC)
  print("## Usage ##")
  print()
  print("`````")
  print(USAGE)
  print("`````")
  print()
  print("## Installation ##")
  print()
  print(INSTALLATION)
  print("## TeXworks setup ##")
  print()
  print(TEXWORKS)
  print()
  print("## Development place ##")
  print()
  print(DEVELPLACE)
  print()
  print("## Changelog ##")
  print()
  print(CHANGELOG)
  print("## Copyright and License ##")
  print()
  print(LICENSECOPYRIGHT)
end

function help()
  print(NAME .. ": " .. SHORTDESC)
  print()
  print("Author: " .. AUTHOR)
  print()
  print(LONGDESC)
  print(USAGE)
end

function fullhelp()
  help()
  print("Installation")
  print("------------")
  print(INSTALLATION)
  print("TeXworks setup")
  print("--------------")
  print(TEXWORKS)
  print("Development place")
  print("-----------------")
  print(DEVELPLACE)
  print()
  print("Copyright and License")
  print("---------------------")
  print(LICENSECOPYRIGHT)
end

function whoami ()
  print("This is " .. NAME .. " version ".. VERSION .. ".")
end

function print_ifdebug(message) -- for debugging: accepts only one argument
  --print("DEBUG: " .. message) -- uncomment for debugging
end

function slashify(str) -- replace "\" with "/", mainly for path strings on cp932 windows
  return (tostring(str):gsub("[\x81-\x9f\xe0-\xfc]?.", { ["\\"] = "/" }))
end

if #arg == 0 then
  usage()
  os.exit(0)
end

-- defaults:
tex = "ptex"
texopts = ""
dvipdf = "dvipdfmx"
dvipdfopts = ""
intermediate = 1

use_eptex = 0
use_uptex = 0
use_latex = 0
outputdir = "."
prefilename = ""
filename = ""
bname = ""
exit_code = 0
narg = 1
repeat
  this_arg = arg[narg]
  -- replace double dash by single dash at the beginning
  this_arg = string.gsub(this_arg, "^%-%-", "-")

  if this_arg == "-v" then
    whoami()
    os.exit(0)
  elseif this_arg == "-readme" then
    makereadme()
    os.exit(0)
  elseif this_arg == "-output-directory" then
    narg = narg+1
    outputdir = arg[narg]
  elseif (string.sub(this_arg, 1, 18) == "-output-directory=") then
    outputdir = string.sub(this_arg, 19, -1)
  elseif this_arg == "-print-version" then
    print(VERSION)
    os.exit(0)
  elseif this_arg == "-h" then
    help()
    os.exit(0)
  elseif this_arg == "-help" then
    fullhelp()
    os.exit(0)
  elseif this_arg == "-e" then
    use_eptex = 1
  elseif this_arg == "-u" then
    use_uptex = 1
  elseif this_arg == "-l" then
    use_latex = 1
  elseif this_arg == "-s" then
    dvipdf = ""
  elseif this_arg == "-i" then
    intermediate = 0
  elseif this_arg == "-ot" then
    narg = narg+1
    texopts = arg[narg]
  elseif (string.sub(this_arg, 1, 4) == "-ot=") then
    texopts = string.sub(this_arg, 5, -1)
  elseif this_arg == "-od" then
    narg = narg+1
    dvipdfopts = arg[narg]
  elseif (string.sub(this_arg, 1, 4) == "-od=") then
    dvipdfopts = string.sub(this_arg, 5, -1)
  else
    if filename == "" then
      filename = this_arg
    else
      -- when emacs tex-mode is used, this will help store "\nonstopmode\input"
      print("Multiple filename arguments? OK, I'll take the latter one.")
      prefilename = prefilename .. " \"" .. filename .. "\""
      filename = this_arg
    end
  end --if this_arg == ...
  narg = narg+1
until narg > #arg 

whoami()

if use_eptex == 1 then
  if use_uptex == 1 then
    if use_latex == 1 then
      tex = "uplatex"	-- uplatex already as etex extension
    else
      tex = "euptex"
    end
  else
    if use_latex == 1 then
      tex = "platex"    -- latex needs etex anyway
    else
      tex = "eptex"
    end
  end
else
  if use_uptex == 1 then
    if use_latex == 1 then
      tex = "uplatex"
    else
      tex = "uptex"
    end
  else
    if use_latex == 1 then
      tex = "platex"
    else
      tex = "ptex"
    end
  end
end

-- initialize kpse
kpse.set_program_name(tex)

-- filename searching
-- first search for the file as is,
-- if not found, try file .tex, if that not found, file .ltx

if ( filename == "" ) then
  print("No filename argument given, exiting.")
  os.exit(1)
else
  filename = slashify(filename)
  if ( kpse.find_file(filename) == nil ) then
    -- try .tex extension
    if ( kpse.find_file(filename .. ".tex") == nil ) then
      -- last try .ltx
      if ( kpse.find_file(filename .. ".ltx") == nil ) then
        print("File cannot be found with kpathsea: ", filename .. "[.tex, .ltx]")
        os.exit(1)
      else
        bname = filename
        filename = filename .. ".ltx"
      end
    else
      bname = filename
      filename = filename .. ".tex"
    end
  else
    -- if it has already an extension, we need to drop it to get the dvi name
    bname = string.gsub(filename, "^(.*)%.[^.]+$", "%1")
  end
  -- filename may contain "/", but the intermediate output is written
  -- in current directory, so we need to drop it
  -- note that all "\" has been replaced with "/"
  bname = string.gsub(bname, "^.*/(.*)$", "%1")
end

-- we are still here, so we found a file
-- make sure that on Windows/uptex we are using utf8 as command line encoding
if os.type == 'windows' then
  if use_uptex == 1 then
    os.setenv('command_line_encoding', 'utf8')
  else
    os.setenv('command_line_encoding', 'none')
  end
end
if (outputdir ~= ".") then
  texopts = "-output-directory \"" .. outputdir .. "\" " .. texopts
  bname = outputdir .. "/" .. bname
  dvipdfopts = "-o \"" .. bname .. ".pdf\""
end
print("Processing ".. filename)
if (os.execute(tex .. " " .. texopts .. prefilename .. " \"" .. filename .. "\"") == 0) and
   (dvipdf == "" or  (os.execute(dvipdf .. " " .. dvipdfopts .. " \"" .. bname .. ".dvi" .. "\"") == 0)) then 
  if dvipdf ~= "" then 
    print(bname .. ".pdf generated by " .. dvipdf .. ".")
  end
  if intermediate == 1 then -- clean-up:
    if dvipdf ~= "" then
      os.remove( bname .. ".dvi" )
    end
  end
else
  print("ptex2pdf processing of " .. filename .. " failed.\n")
  print_ifdebug("tex = " .. tex)
  print_ifdebug("dvipdf = " .. dvipdf)
  os.exit(2)
end

-- all done ... exit with success
os.exit( 0 )



-- Local Variables:
-- lua-indent-level: 2
-- tab-width: 2
-- indent-tabs-mode: nil
-- End:
-- vim:set tabstop=2 expandtab: #
