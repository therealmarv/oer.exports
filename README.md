# oer.exports

To install and get it running:

# System Dependencies

Tested with python 2.4 and python 2.7 but it will probably work with all versions in between.

## For Ubuntu/Debian

    sudo apt-get install python-virtualenv                   # for the following commands
    sudo apt-get install libxslt1-dev libxml2-dev zlib1g-dev # For lxml to compile
    sudo apt-get install librsvg2-bin                        # To convert SVG and math to PNG
    sudo apt-get install otf-stix

also:

    apt-get install imagemagick                    # PNG resizing
    apt-get install inkscape                       # svg processing
    apt-get install ruby                           # Hmmm...
    apt-get install libxml2-utils                  # for xmllint
    apt-get install zip                            # building the zip
    apt-get install openjdk-7-jre-headless
    apt-get install docbook-xsl-ns
    apt-get install xsltproc                       # for generating epub
    
# For Osx

Install http://mxcl.github.com/homebrew/

    brew install librsvg
    brew install imagemagick
    brew install node           # Only if you want to compile the `.less` files
    sudo npm install -g less    # Only if you want to compile the `.less` files


Install python virtualenv

    sudo easy_install virtualenv

## For all Operating Systems

This will set up the virtual environment in your terminal (all packages are not installed globally).

    cd oer.exports
    virtualenv .
    source bin/activate
    easy_install lxml argparse pillow

Once you run these steps, every time you open a terminal you will need to run `source bin/activate`.

## Install PrinceXML

Finally, you will need to install http://princexml.com (remember the path to where it gets installed, or use "which prince").

## Optional: Local docbook-xsl files

The `docbook-xsl` has files that point to http://docbook.sourceforge.net . Loading these is slow and sometimes times out.

You can download the zip file from http://sourceforge.net/projects/docbook/files/docbook-xsl-ns/ (1.72 works) and replace the `docbook-xsl` directory with its contents.

## Install Fonts

The styles used in these books use openly licensed fonts found in Ubuntu. The fonts can be found at http://mountainbunker.org/~ew2/fonts/truetype-open-fonts.zip

# Generate Books

Ok, let's make sure you can create a PDF and EPUB!

To generate a PDF:

    python collectiondbk2pdf.py -p ${path-to-wkhtml2pdf-or-princexml} -d ./test-ccap -s ccap-physics ./result.pdf

To generate an EPUB:

    ./scripts/module2epub.sh "Connexions" ./test-ccap ./test-ccap.epub "col12345" ./xsl/dbk2epub.xsl ./static/content.css

Alternative script for EPUB:

    # For a collection:
    python content2epub.py -c ./static/content.css -e ./xsl/dbk2epub.xsl -t "collection" -o ./test-ccap.epub ./test-ccap/

    # For just a module:
    python content2epub.py -c ./static/content.css -e ./xsl/dbk2epub.xsl -t "module" -o ./m123.epub -i "m123" ./test-ccap/m-section/

## Testing PDF output for diffs

In the /tools directory is a Ubuntu based pdfdiff tool for checking two files or two entire directories with PDFs for diffs in content and styling. Please look at the README.md in /tools .

# License:

This software is subject to the provisions of the GNU Affero General Public License Version 3.0 (AGPL). See license.txt for details. Copyright (c) 2012 Rice University
