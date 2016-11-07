
util.download <- function(url, dir=NULL, file=NULL, alwaysDownload=F) {
  #ext <- tail( unlist( stringr::str_split(filename, "\\.") ), n=1)
  #filename_extract <- paste0("file",".",ext)
  if(!is.null(file)) {
    filename <- file
  }
  else {
    filename <- tail( unlist( stringr::str_split(url, "/") ), n=1 )
  }
  if( (!is.null(dir) && !(dir=='')) )  {
    dir <- paste0(dir, "/")
  }

  filename_download <- paste0(dir, filename)
  if( alwaysDownload || (!file.exists(filename_download)) ) {
    download.file(url, filename_download)
  }
  return(filename_download)
}

util.downloadAndUnzip <- function(url, dir=NULL, file=NULL, alwaysDownload=F) {
  filename <- util.download(url, dir, file, alwaysDownload)
  if(stringr::str_detect(filename, "zip$")) {
    filename <- unzip(filename, exdir = ifelse(is.null(dir), ".", dir) )
  }
  return(filename)
}
