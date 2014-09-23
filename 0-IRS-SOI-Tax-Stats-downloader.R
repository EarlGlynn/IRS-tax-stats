# Download IRS tax stats files for study.

# Explore IRS tax stats as possible surrogate for socioeconomic level by ZIP code area.
# http://www.irs.gov/uac/SOI-Tax-Stats-Individual-Income-Tax-Statistics-ZIP-Code-Data-(SOI)

# According to David Jordan, IRS Statistics of Income Division, data for
# tax years 2009 and 2010 "are scheduled for release at the end of 2014"
# (2014-06-26).  "What's New" announced data available for 2009 and 2010 (2014-09-22).
# http://www.irs.gov/uac/SOI-Tax-Stats-What's-New

# UMKC Center for Health Insights
# Earl F Glynn, 2014-06-27.  Updated 2014-09-23.

DATA.DIR <- "DATA"

setwd("C:/Data/US-Government/IRS/SOI-Tax-Stats/")  ##### Modify as appropriate
options(width=100)
sink("0-IRS-SOI-Tax-Stats-downloader.txt", split=TRUE)

print(Sys.time())

if (! file.exists(DATA.DIR) )
{
  dir.create(DATA.DIR)
}

library(downloader)  # platform neutral download function
library(tools)       # md5sum

URL.BASE <- "http://www.irs.gov/file_source/pub/irs-soi/"

filenames <- c("2012zipcode.zip",                    # Available 2014-07-15
               "2011zipcode.zip",
               "2010zipcode.zip", "2009zipcode.zip", # Available 2014-09-22
               "2008zipcode.zip", "2007zipcode.zip",
               "2006zipcode.zip", "2005zipcode.zip",
               "2004zipcode.zip",                    # Where's 2003?
               "2002zipcode.zip",
               "2001zipcode.zip", "1998zipcode.zip")

for (i in 1:length(filenames))
{
  # Create separate directory by year since there is no one rule
  # applied across all years.
  year <- substr(filenames[i], 1, 4)
  cat("\n*****", year, "*****\n")

  # The IRS is inconsistent on whether zipped files are or are not in a
  # folder in the ZIP.  Kludge fix for now.
  if (year > 2008)   # 2009 - 2012 for now
  {
    year.dir <- paste0(DATA.DIR, "/", year, "ZipCode")
    if (! file.exists(year.dir) )
    {
      dir.create(year.dir)
    }
  } else {
    year.dir <- DATA.DIR
  }

  download.url <- paste0(URL.BASE, filenames[i])
  zip.filename <- paste0(year.dir, "/", filenames[i])
  download(download.url, zip.filename, mode = "wb")
  print( md5sum(zip.filename) )
  unzip(zip.filename, exdir=year.dir)
  print(Sys.time())
}

print( file.info(list.files(path=year.dir, full.names=TRUE, recursive=TRUE)) )

# Deal with IRS inconsistencies in directory/filenames manually instead
# of programmatically, e.g., move ZIPs for 2009 to 2012 to DATA directory,
# remove .tmp files from 2009.
#
# 2011 has useful summary files in .csv files, but such files were not
# provided in earlier years.

sink()

